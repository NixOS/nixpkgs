#include "qemu/osdep.h"
#include "qemu-common.h"
#include "qemu/timer.h"
#include "ui/console.h"

#include <zlib.h>

static DisplayChangeListener *dcl;
static gzFile output_video;

/* These values are directly used in our intermediate format so that they can
 * later be mapped back in avutil. The constants here are just so that we have
 * the same naming conventions as avutil.
 *
 * Note also, that this is used in an uint8_t so be careful to not overflow and
 * also make sure that in case it is a packed pixel format it needs to be big
 * endian. The necessary conversion for little endian systems is done when we
 * encode it into a more common video format.
 */
#define AV_PIX_FMT_RGB555BE 1
#define AV_PIX_FMT_RGB565BE 2
#define AV_PIX_FMT_0RGB     3
#define AV_PIX_FMT_RGB0     4
#define AV_PIX_FMT_BGR0     5

static bool write_packet(void *buf, size_t len)
{
    int i, written;

    for (i = 0; i < len; i += written) {
        written = gzwrite(output_video, buf + i, len - i);
        if (written <= 0) {
            fputs("Error writing compressed video packet.\n", stderr);
            return false;
        }
    }

    return true;
}

static void nixos_test_update(DisplayChangeListener *dcl,
                              int x, int y, int w, int h)
{
    DisplaySurface *surf = qemu_console_surface(dcl->con);
    uint32_t x32 = x, y32 = y, w32 = w, h32 = h;
    uint64_t timestamp;
    size_t offset, datalen;
    void *buf, *bufp, *sdata;

    if (surf == NULL)
        return;

    timestamp = qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
    offset = surface_bytes_per_pixel(surf) * x + surface_stride(surf) * y;
    datalen = surface_bytes_per_pixel(surf) * w * h;

    /* Bitstring: <<Op:8, X:32, Y:32, W:32, H:32, Time:64, Data/binary>>
     * Length:    1 + 4 + 4 + 4 + 4 + 8 + DataLen = 25 + DataLen
     */
    buf = g_malloc(25 + datalen);
    *(char*)buf = 'U';
    memcpy(buf + 1,  &x32,       4);
    memcpy(buf + 5,  &y32,       4);
    memcpy(buf + 9,  &w32,       4);
    memcpy(buf + 13, &h32,       4);
    memcpy(buf + 17, &timestamp, 8);

    bufp = buf + 25;
    sdata = surface_data(surf) + offset;

    /* Extract only the data of the rectangle but also taking stride into
     * account, so we don't need to handle padding while encoding this
     * intermediate format into a common video format.
     */
    while (h-- > 0) {
        memcpy(bufp, sdata, w * surface_bytes_per_pixel(surf));
        sdata += surface_stride(surf);
        bufp += w * surface_bytes_per_pixel(surf);
    }

    if (!write_packet(buf, 25 + datalen)) {
        g_free(buf);
        exit(1);
    }
    g_free(buf);
}

static void nixos_test_switch(DisplayChangeListener *dcl,
                              DisplaySurface *new_surface)
{
    void *buf;
    uint32_t width, height;
    uint8_t format, bpp;

    if (new_surface == NULL)
        return;

    width = surface_width(new_surface);
    height = surface_height(new_surface);
    bpp = surface_bytes_per_pixel(new_surface);

    switch (new_surface->format) {
        case PIXMAN_x1r5g5b5: format = AV_PIX_FMT_RGB555BE; break;
        case PIXMAN_r5g6b5:   format = AV_PIX_FMT_RGB565BE; break;
        case PIXMAN_x8r8g8b8: format = AV_PIX_FMT_0RGB;     break;
        case PIXMAN_r8g8b8x8: format = AV_PIX_FMT_RGB0;     break;
        case PIXMAN_b8g8r8x8: format = AV_PIX_FMT_BGR0;     break;
        default: return;
    }

    /* Bitstring: <<Op:8, Width:32, Height:32, Format:8, BPP:8>>
     * Length:    1 + 4 + 4 + 1 + 1 = 11
     */
    buf = g_malloc(11);
    *(char*)buf = 'S';
    memcpy(buf + 1,  &width,  4);
    memcpy(buf + 5,  &height, 4);
    memcpy(buf + 9,  &format, 1);
    memcpy(buf + 10, &bpp,    1);

    if (!write_packet(buf, 11)) {
        g_free(buf);
        exit(1);
    }
    g_free(buf);

    /* We have a new surface (or a resize), so we need to send an update for
     * the whole new surface size to make sure we don't get artifacts from the
     * old surface. */
    nixos_test_update(dcl, 0, 0, surface_width(new_surface),
                      surface_height(new_surface));
}

static void nixos_test_refresh(DisplayChangeListener *dcl)
{
    graphic_hw_update(dcl->con);
}

static bool nixos_test_check_format(DisplayChangeListener *dcl,
                                    pixman_format_code_t format)
{
    switch (format) {
        case PIXMAN_x1r5g5b5:
        case PIXMAN_r5g6b5:
        case PIXMAN_x8r8g8b8:
        case PIXMAN_r8g8b8x8:
        case PIXMAN_b8g8r8x8:
            return true;
        default:
            return false;
    }
}

static const DisplayChangeListenerOps dcl_ops = {
    .dpy_name             = "nixos-test",
    .dpy_gfx_update       = nixos_test_update,
    .dpy_gfx_switch       = nixos_test_switch,
    .dpy_gfx_check_format = nixos_test_check_format,
    .dpy_refresh          = nixos_test_refresh,
};

static void nixos_test_cleanup(void)
{
    gzclose_w(output_video);
}

#define HEADER \
    "# This file contains raw frame data in an internal format used by\n" \
    "# the 'nixos-test' QEMU UI module optimized for low overhead.\n" \
    "#\n" \
    "# In order to get this into a format that's actually watchable,\n" \
    "# please use the 'nixos-test-encode-video' binary from the\n" \
    "# 'qemu_test.tools' package to encode it into another video format.\n" \
    "#\n"
#define HEADER_SIZE sizeof(HEADER) - 1

static void nixos_test_display_init(DisplayState *ds, DisplayOptions *o)
{
    int outfd;
    QemuConsole *con;

    outfd = qemu_open(o->capture_file,
                      O_WRONLY | O_CREAT | O_APPEND | O_BINARY, 0666);

    if (outfd < 0) {
        fprintf(stderr, "Failed to open file '%s' for video capture: %s\n",
                o->capture_file, strerror(errno));
        exit(1);
    }

    /* When at the beginning of the file, let's write a short description about
     * the file in question so that people stumbling over it know what to do
     * with it.
     */
    if (lseek(outfd, 0, SEEK_END) == 0) {
        if (qemu_write_full(outfd, HEADER, HEADER_SIZE) != HEADER_SIZE) {
            fprintf(stderr, "Unable to write video file header to '%s'.\n",
                    o->capture_file);
            exit(1);
        }
    }

    /* We're using gzip here because we have a lot of repetition in frame data
     * and a test run without compressing the intermediate format can easily
     * grow to a few gigabytes, which will also cause slowdowns on slow disks.
     */
    if ((output_video = gzdopen(outfd, "ab1")) == NULL) {
        fprintf(stderr, "Unable to associate gzip stream with '%s'.\n",
                o->capture_file);
        qemu_close(outfd);
        exit(1);
    }

    con = qemu_console_lookup_by_index(0);
    if (!con) {
        fputs("Unable to look up console 0.\n", stderr);
        exit(1);
    }

    dcl = g_new0(DisplayChangeListener, 1);
    dcl->ops = &dcl_ops;
    dcl->con = con;
    register_displaychangelistener(dcl);

    fprintf(stderr, "Capturing intermediate video stream to '%s'.\n",
            o->capture_file);

    atexit(nixos_test_cleanup);
}

static QemuDisplay qemu_display_nixos_test = {
    .type       = DISPLAY_TYPE_NIXOS_TEST,
    .init       = nixos_test_display_init,
};

static void register_nixos_test(void)
{
    qemu_display_register(&qemu_display_nixos_test);
}

type_init(register_nixos_test);
