#include <fcntl.h>
#include <stdbool.h>
#include <byteswap.h>

#include <libavformat/avformat.h>
#include <libswscale/swscale.h>

#include <zlib.h>

/* This is needed in order to distinguish between real errors and read failures
 * indicating EOF, so that we can exit gracefully if errors happen.
 */
static bool is_error;

struct bound_info {
    uint32_t width;
    uint32_t height;
    uint64_t start_time;
    size_t frames;
};

struct packet_switch {
    uint32_t width;
    uint32_t height;
    enum AVPixelFormat format;
    uint8_t bpp;
};

struct packet_update {
    uint32_t x;
    uint32_t y;
    uint32_t w;
    uint32_t h;
    uint64_t timestamp;
    size_t datalen;
};

/* Use AVIO to open the file if the URL is pointing to a file instead of for
 * example streaming it over network.
 */
static bool maybe_open_avio(AVFormatContext *context, const char *uri)
{
    int ret;

    if (context->oformat->flags & AVFMT_NOFILE)
        return true;

    if ((ret = avio_open(&context->pb, uri, AVIO_FLAG_WRITE)) < 0) {
        fprintf(stderr, "Unable to open '%s': %s\n", uri, av_err2str(ret));
        return false;
    }

    return true;
}

/* Close AVIO if the passed URL is a file. */
static void maybe_close_avio(AVFormatContext *context)
{
    if (context->oformat->flags & AVFMT_NOFILE)
        return;

    avio_closep(&context->pb);
}

/* Read bytes from the input stream with the given length and allocate a buffer
 * large enough.
 */
static void *alloc_read(gzFile ifile, size_t len)
{
    void *buf;
    int i, readlen;

    is_error = false;

    if ((buf = malloc(len)) == NULL) {
        fprintf(stderr, "Unable to allocate buffer for "
                "intermediate video packet: %s\n", strerror(errno));
        is_error = true;
        return NULL;
    }

    for (i = 0; i < len; i += readlen) {
        readlen = gzread(ifile, buf + i, len - i);
        if (readlen <= 0) {
            free(buf);
            /* Don't print an error because we want to make sure that whenever
             * the stream ends prematurely, we still do have a valid video.
             */
            if (readlen < 0) {
                fprintf(stderr, "Unable to read %zu bytes from input file.",
                        len - i);
                is_error = true;
            }
            return NULL;
        }
    }

    return buf;
}

/* The packed pixel format from QEMU (and thus Pixman) is using 2 or 4 byte
 * sequences which are in native host byte order. FFmpeg on the other hand
 * expects 8-bit sequences, so we need to convert it to big endian as all of
 * the pixel formats we've choosen for FFmpeg are big endian (either explicitly
 * or implicitly).
 */
static bool convert_endian(void *data, size_t len, uint8_t bpp)
{
    const uint16_t endian_test = 1;

    if (*(uint8_t*)&endian_test == 0)
        return true;

    switch (bpp) {
        case 2:
            for (int i = 0; i < len; ++i, data += bpp)
                *(uint16_t*)data = bswap_16(*(uint16_t*)data);
            break;
        case 4:
            for (int i = 0; i < len; ++i, data += bpp)
                *(uint32_t*)data = bswap_32(*(uint32_t*)data);
            break;
        default:
            fprintf(stderr, "Unable to handle pixel byte size of %d.\n", bpp);
            return false;
    }
    return true;
}

static AVFrame *alloc_frame(enum AVPixelFormat pix_fmt, uint32_t width,
                            uint32_t height)
{
    AVFrame *frame;

    if ((frame = av_frame_alloc()) == NULL)
        return NULL;

    frame->format = pix_fmt;
    frame->width  = width;
    frame->height = height;

    if (av_frame_get_buffer(frame, 0) < 0) {
        fprintf(stderr, "Could not allocate frame data.\n");
        return NULL;
    }

    return frame;
}

/* Parse a switch packet (indicated by an 'S' byte).
 *
 * The format is (numbers after colons are bit sizes):
 *
 * <<Width:32, Height:32, Format:8, BPP:8>>
 */
static struct packet_switch *parse_switch(gzFile ifile)
{
    void *buf;
    struct packet_switch *out;
    uint8_t tmp_format;

    if ((buf = alloc_read(ifile, 10)) == NULL)
        return NULL;

    if ((out = malloc(sizeof(struct packet_switch))) == NULL) {
        fprintf(stderr, "Unable to allocate packet_switch: %s\n",
                strerror(errno));
        is_error = true;
        free(buf);
        return NULL;
    }

    memcpy(&out->width,  buf,     4);
    memcpy(&out->height, buf + 4, 4);
    memcpy(&tmp_format,  buf + 8, 1);
    memcpy(&out->bpp,    buf + 9, 1);

    free(buf);

    switch (tmp_format) {
        case 1: out->format = AV_PIX_FMT_RGB555BE; break;
        case 2: out->format = AV_PIX_FMT_RGB565BE; break;
        case 3: out->format = AV_PIX_FMT_0RGB;     break;
        case 4: out->format = AV_PIX_FMT_RGB0;     break;
        case 5: out->format = AV_PIX_FMT_BGR0;     break;
        default:
            fprintf(stderr, "Unknown pixel format %d in switch directive.\n",
                    tmp_format);
            is_error = true;
            free(out);
            return NULL;
    }

    return out;
}

/* Parse an update packet (indicated by an 'U' byte).
 *
 * The format is (numbers after colons are bit sizes):
 *
 * <<Op:8, X:32, Y:32, W:32, H:32, Time:64>>
 *
 * The actual data length is determined by the given bytes per pixel
 * and the width and height of the update packet, which is also saved
 * into the returned struct.
 */
static struct packet_update *parse_update(gzFile ifile, uint8_t bpp)
{
    void *buf;
    struct packet_update *out;

    if ((buf = alloc_read(ifile, 24)) == NULL)
        return NULL;

    if ((out = malloc(sizeof(struct packet_update))) == NULL) {
        fprintf(stderr, "Unable to allocate packet_update: %s\n",
                strerror(errno));
        is_error = true;
        free(buf);
        return NULL;
    }

    memcpy(&out->x,         buf,      4);
    memcpy(&out->y,         buf + 4,  4);
    memcpy(&out->w,         buf + 8,  4);
    memcpy(&out->h,         buf + 12, 4);
    memcpy(&out->timestamp, buf + 16, 8);

    free(buf);

    out->datalen = out->w * bpp * out->h;

    return out;
}

/* Get the boundaries of the video by seeking through all of the frames.
 *
 * This is to get the maximum width and height, so we can scale every frame to
 * these dimensions. It also returns the amount of frames so we can show the
 * progress.
 */
static struct bound_info *get_bounds(gzFile ifile)
{
    struct bound_info *out;
    uint32_t width = 0, height = 0;
    uint64_t start_time = 0;
    uint8_t bpp = 0;
    size_t frames = 0;
    char opcode;

    struct packet_switch *sw = NULL;
    struct packet_update *up;

    while (!gzeof(ifile)) {
        opcode = gzgetc(ifile);
        switch (opcode) {
            case 'S':
                if ((sw = parse_switch(ifile)) == NULL) {
                    if (is_error)
                        return NULL;
                    else
                        goto eof;
                }
                bpp = sw->bpp;
                if (sw->width > width)
                    width = sw->width;
                if (sw->height > height)
                    height = sw->height;
                free(sw);
                break;
            case 'U':
                if ((up = parse_update(ifile, bpp)) == NULL) {
                    if (is_error)
                        return NULL;
                    else
                        goto eof;
                }
                if (start_time == 0)
                    start_time = up->timestamp;
                if (gzseek(ifile, up->datalen, SEEK_CUR) == -1) {
                    free(up);
                    goto eof;
                }
                free(up);
                frames++;
                break;
            case -1:
                if (gzeof(ifile))
                    goto eof;
            default:
                fprintf(stderr, "Unknown opcode 0x%02x when parsing "
                        "intermediate format.\n", opcode);
                return NULL;
        }
    }

eof:

    if (width == 0 || height == 0) {
        fprintf(stderr, "Couldn't get size after processing %zu frames.\n",
                frames);
        return NULL;
    }

    if ((out = malloc(sizeof(struct bound_info))) == NULL) {
        fprintf(stderr, "Unable to allocate bound_info: %s\n",
                strerror(errno));
        return NULL;
    }

    out->width = width;
    out->height = height;
    out->start_time = start_time;
    out->frames = frames;

    gzrewind(ifile);
    return out;
}

/* Encodes a single frame by also handling dropping of frames that have the
 * same presentation time stamp in the target format.
 *
 * So while we have nanoseconds in our input format, the output format might
 * not support such a precision, so when we round down nanoseconds to a format
 * with less precision, duplicates could occur.
 *
 * When dropping frames, we only drop the initial duplicates because we
 * otherwise would end up with an inconsistent frame.
 *
 * To illustrate this with an example:
 *
 * Update 1: X 0, Y 0, W 1, H 1
 * Update 2: X 1, Y 1, W 1, H 1
 * Update 3: X 2, Y 2, W 1, H 1
 *
 * If we drop subsequent duplicate frames, the frame that is going to be
 * encoded would be update 1, which would include only the least complete
 * information about the frame. So we do updates 1-3 and encode the result of
 * all the updates into a single frame.
 */
static bool encode_frame(AVCodecContext *context, AVFormatContext *fcontext,
                         AVStream *stream, AVFrame *frame, AVPacket *packet)
{
    int ret;
    int64_t new_pts;
    static int64_t last_pts = 0;

    new_pts = av_rescale_q(frame->pts, context->time_base, stream->time_base);

    if (last_pts >= new_pts)
        return true;

    last_pts = new_pts;

    ret = avcodec_send_frame(context, frame);

    if (ret == AVERROR(EAGAIN)) {
        ret = avcodec_receive_packet(context, packet);
        if (ret == AVERROR_EOF)
            return true;
        else if (ret < 0) {
            fprintf(stderr, "Error encoding frame: %s\n",
                    av_err2str(ret));
            return false;
        }

        av_packet_rescale_ts(packet, context->time_base, stream->time_base);
        av_interleaved_write_frame(fcontext, packet);
        av_packet_unref(packet);

        return encode_frame(context, fcontext, stream, frame, packet);
    }

    return true;
}

static bool encode_frames(gzFile ifile, AVCodecContext *context,
                          AVFormatContext *fcontext, AVStream *stream,
                          AVFrame *oframe, uint64_t start_time, size_t frames)
{
    bool status = true;
    char opcode;
    size_t offset;
    void *data;
    size_t frameno = 0;

    struct packet_switch *sw = NULL;
    struct packet_update *up;

    struct SwsContext *swcontext = NULL;
    AVFrame *frame;
    AVPacket *packet;

    packet = av_packet_alloc();

    while (!gzeof(ifile)) {
        opcode = gzgetc(ifile);
        switch (opcode) {
            case 'S':
                if (sw != NULL) {
                    sws_freeContext(swcontext);
                    av_frame_free(&frame);
                    free(sw);
                }

                if ((sw = parse_switch(ifile)) == NULL) {
                    if (is_error)
                        goto out_err;
                    else
                        goto out;
                }

                /* We need to reinitialise this for *every* switch packet, not
                 * only for surfaces that have the target video size, because
                 * this also handles pixel format conversions.
                 */
                swcontext = sws_getContext(sw->width, sw->height, sw->format,
                                           context->width, context->height,
                                           context->pix_fmt, SWS_BICUBIC,
                                           NULL, NULL, NULL);
                if (swcontext == NULL) {
                    fputs("Couldn't initialize conversion context!\n", stderr);
                    goto out_err;
                }

                frame = alloc_frame(sw->format, sw->width, sw->height);
                av_frame_make_writable(frame);
                memset(frame->data[0], 0, sw->height * sw->width * sw->bpp);

                break;
            case 'U':
                if (sw == NULL)
                    continue;

                if ((up = parse_update(ifile, sw->bpp)) == NULL) {
                    if (is_error)
                        goto out_err;
                    else
                        goto out;
                }

                if ((data = alloc_read(ifile, up->datalen)) == NULL) {
                    free(up);
                    goto out;
                }

                if (!convert_endian(data, up->w * up->h, sw->bpp)) {
                    free(up);
                    free(data);
                    goto out_err;
                }

                av_frame_make_writable(frame);
                offset = up->x * sw->bpp + up->y * sw->width * sw->bpp;
                memcpy(frame->data[0] + offset, data, up->datalen);

                /* We need to convert the presentation time stamp to
                 * milliseconds because a lot of formats can't handle such a
                 * precision.
                 */
                oframe->pts = (up->timestamp - start_time) / 1000000;

                free(up);
                free(data);

                sws_scale(swcontext, (const uint8_t * const *)frame->data,
                          frame->linesize, 0, sw->height, oframe->data,
                          oframe->linesize);

                fprintf(stderr, "\rEncoding frame %zu of %zu... ", ++frameno,
                        frames);
                fflush(stderr);

                if (!encode_frame(context, fcontext, stream, oframe, packet))
                    goto out_err;

                break;
            case -1:
                if (gzeof(ifile))
                    goto out;
            default:
                fprintf(stderr, "Unknown opcode 0x%02x when parsing "
                        "intermediate format.\n", opcode);
                goto out_err;
        }
    }

    goto out;

out_err:
    status = false;

out:
    fprintf(stderr, "\rEncoded %zu frames out of %zu.\n", frameno, frames);

    if (sw != NULL) {
        sws_freeContext(swcontext);
        av_frame_free(&frame);
        free(sw);
    }

    av_packet_free(&packet);

    return status;
}

/* Skip the header, which contains a description about how to encode the video
 * format.
 *
 * The header is using a typical comment-style format that uses lines that
 * start with '#' and are delimited by '\n'. So all we need to do here is to
 * skip everything until we get the first '\n' not followed by '#'.
 *
 * If the actual video format would contain a # at the start, we would be in
 * trouble, but it's not the case for gzip because it always starts with the
 * identifier 0x1F8B.
 */
static bool skip_header(int fd)
{
    ssize_t ret;
    char prev, cur;

    for (prev = '\0'; (ret = read(fd, &cur, 1)) == 1; prev = cur) {
        if (prev == '\n' && cur != '#') {
            lseek(fd, -1, SEEK_CUR);
            return true;
        }
    }

    if (ret == 0)
        fputs("End of file while trying to skip header.\n", stderr);
    else if (ret == -1)
        fprintf(stderr, "Unable to read while skipping header: %s\n",
                strerror(errno));
    else
        fputs("Unable to find the end of the header.\n", stderr);

    return false;
}

static int get_thread_count(void)
{
    int threadcount;
    char *tmp;

    /* Use the value from NIX_BUILD_CORES and fall back to av_cpu_count() if
     * it's either unset (when not within a Nix build process) or it's 0.
     */
    if ((tmp = getenv("NIX_BUILD_CORES")) == NULL)
        threadcount = av_cpu_count();
    else if ((threadcount = atoi(tmp)) == 0)
        threadcount = av_cpu_count();

    /* Use a maximum of 16 threads, otherwise libvpx bails out with a warning
     * like this:
     *
     *   Application has requested 48 threads. Using a thread count greater
     *   than 16 is not recommended.
     */
    if (threadcount > 16)
        threadcount = 16;

    return threadcount;
}

/* Small helper macro to ensure that error handling doesn't clutter up
 * readability.
 */
#define DICT_SET_INT(key, value) \
    if ((ret = av_dict_set_int(&opt, #key, value, 0)) < 0) { \
        fprintf(stderr, "Error setting '" #key "' to '" #value "': %s\n", \
                av_err2str(ret)); \
        goto out_err; \
    }

int main(int argc, char **argv)
{
    gzFile ifile;
    int ret, ecode = EXIT_SUCCESS, tmpfd;
    struct bound_info *bounds;
    uint64_t start_time;
    size_t frames;

    const AVCodec *codec;
    AVFormatContext *fcontext = NULL;
    AVCodecContext *context = NULL;
    AVStream *stream;
    AVFrame *oframe = NULL;
    AVDictionary *opt = NULL;

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <intermediate_format_file> <output_file>\n",
                argv[0]);
        return EXIT_FAILURE;
    }

    if ((tmpfd = open(argv[1], O_RDONLY)) == -1) {
        fprintf(stderr, "Unable to open input file '%s'.\n", argv[1]);
        return EXIT_FAILURE;
    }

    if (!skip_header(tmpfd))
        return EXIT_FAILURE;

    if ((ifile = gzdopen(tmpfd, "rb")) == NULL) {
        fprintf(stderr, "Unable to open compressed input file '%s'.\n",
                argv[1]);
        return EXIT_FAILURE;
    }

    av_register_all();
    av_dict_copy(&opt, NULL, 0);

    if (avformat_alloc_output_context2(&fcontext, NULL, NULL, argv[2]) < 0) {
        fprintf(stderr, "Couldn't deduce format for output file '%s'.\n",
                argv[2]);
        goto out_err;
    }

    if (fcontext->oformat->video_codec == AV_CODEC_ID_NONE) {
        fprintf(stderr, "Unable to determine video codec for '%s'.\n",
                argv[2]);
        goto out_err;
    }

    codec = avcodec_find_encoder(fcontext->oformat->video_codec);
    if (codec == NULL) {
        fprintf(stderr, "Could not find video encoder for '%s'.\n",
                avcodec_get_name(fcontext->oformat->video_codec));
        goto out_err;
    }

    if ((stream = avformat_new_stream(fcontext, NULL)) == NULL) {
        fputs("Unable to allocate stream.\n", stderr);
        goto out_err;
    }

    if ((context = avcodec_alloc_context3(codec)) == NULL) {
        fputs("Unable to allocate context for video codec.\n", stderr);
        goto out_err;
    }

    if ((bounds = get_bounds(ifile)) == NULL)
        goto out_err;

    context->width = bounds->width;
    context->height = bounds->height;
    start_time = bounds->start_time;
    frames = bounds->frames;

    free(bounds);

    context->codec_id = fcontext->oformat->video_codec;
    context->time_base = (AVRational){1, 1000};

    DICT_SET_INT(threads, get_thread_count());

    switch (context->codec_id) {
        case AV_CODEC_ID_VP8:
        case AV_CODEC_ID_VP9:
            /* Encode VP8 and VP9 in constant quality (CQ) mode, so we need to
             * explicitly set the bit rate to 0.
             */
            context->bit_rate = 0;
            DICT_SET_INT(crf, 30);
            break;
        default:
            context->flags |= CODEC_FLAG_QSCALE;
            context->global_quality = 1 * FF_QP2LAMBDA;
            break;
    }

    if (codec->pix_fmts == NULL) {
        fprintf(stderr, "Unable to determine pixel format for codec '%s'.\n",
                avcodec_get_name(fcontext->oformat->video_codec));
        goto out_err;
    }

    /* Pick the first supported pixel format of the current codec. */
    context->pix_fmt = codec->pix_fmts[0];

    if (avcodec_open2(context, codec, &opt) != 0) {
        fprintf(stderr, "Unable to open context with codec '%s'.\n",
                avcodec_get_name(fcontext->oformat->video_codec));
        goto out_err;
    }

    if (avcodec_parameters_from_context(stream->codecpar, context) < 0) {
        fputs("Unable to copy stream parameters.\n", stderr);
        goto out_err;
    }

    av_dump_format(fcontext, 0, argv[2], 1);

    oframe = alloc_frame(context->pix_fmt, context->width, context->height);
    if (oframe == NULL)
        goto out_err;

    if (!maybe_open_avio(fcontext, argv[2]))
        goto out_err;

    if ((ret = avformat_write_header(fcontext, &opt)) < 0) {
        fprintf(stderr, "Unable to write stream header to '%s': %s\n",
                argv[2], av_err2str(ret));
        goto out_err;
    }

    if (!encode_frames(ifile, context, fcontext, stream, oframe, start_time,
                       frames))
        goto out_err;

    if ((ret = av_write_trailer(fcontext)) < 0) {
        fprintf(stderr, "Unable to write stream trailer to '%s': %s\n",
                argv[2], av_err2str(ret));
        goto out_err;
    }

    goto out;

out_err:
    ecode = EXIT_FAILURE;

out:
    if (oframe != NULL)
        av_frame_free(&oframe);
    if (context != NULL)
        avcodec_free_context(&context);
    if (fcontext != NULL) {
        if (fcontext->pb != NULL)
            maybe_close_avio(fcontext);
        avformat_free_context(fcontext);
    }
    gzclose_r(ifile);
    av_dict_free(&opt);

    return ecode;
}
