# See https://gitlab.com/porn-vault/porn-vault/-/blob/rust-core/config.example.json
{
  binaries = {
    ffmpeg = "ffmpeg";
    ffprobe = "ffprobe";
    imagemagick = {
      convertPath = "convert";
      montagePath = "montage";
      identifyPath = "identify";
    };
  };
  matching = {
    ignoreSingleNames = true;
  };
  processing = {
    generatePreviewStrip = true;
    bookmarkNewScenes = false;
  };
  import = {
    images = [
      {
        path = "/media/porn-vault/images";
        include = [ ];
        exclude = [ ];
        extensions = [
          ".jpg"
          ".jpeg"
          ".png"
          ".gif"
        ];
        enable = true;
      }
    ];
    videos = [
      {
        path = "/media/porn-vault/videos";
        include = [ ];
        exclude = [ ];
        extensions = [
          ".mp4"
          ".mov"
          ".webm"
        ];
        enable = true;
      }
    ];
  };
  persistence = {
    libraryPath = "/media/porn-vault/lib/library";
    tempFolder = "tmp";
  };
  diagnostics = {
    deadAudioChannelDetection = {
      volumeThreshold = -50;
    };
  };
  plugins = {
    events = {
      "scene:created" = [
      ];
    };
    register = {

    };
  };
}
