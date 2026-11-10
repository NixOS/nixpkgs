# See https://gitlab.com/porn-vault/porn-vault/-/blob/dev/config.example.json5
{
  binaries = {
    ffmpeg = "ffmpeg";
    ffprobe = "ffprobe";
    imagemagick = {
      convert = "convert";
      montage = "montage";
      identify = "identify";
    };
  };
  matching = {
    ignoreSingleNames = true;
    applyStudioLabels = true;
    applyActorLabels = true;
    regexAliasesCaseSensitive = false;
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
