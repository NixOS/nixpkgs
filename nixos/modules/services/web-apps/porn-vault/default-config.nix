# See https://gitlab.com/porn-vault/porn-vault/-/blob/dev/config.example.json
{
  auth = {
    password = null;
  };
  binaries = {
    ffmpeg = "ffmpeg";
    ffprobe = "ffprobe";
    izzyPort = 8000;
    imagemagick = {
      convertPath = "convert";
      montagePath = "montage";
      identifyPath = "identify";
    };
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
    scanInterval = 10800000;
  };
  log = {
    level = "debug";
    maxSize = "20m";
    maxFiles = "5";
    writeFile = [
      {
        level = "debug";
        prefix = "errors-";
        silent = false;
      }
    ];
  };
  matching = {
    applyActorLabels = [
      "event:actor:create"
      "event:actor:find-unmatched-scenes"
      "plugin:actor:create"
      "event:scene:create"
      "plugin:scene:create"
      "event:image:create"
      "plugin:marker:create"
      "event:marker:create"
    ];
    applySceneLabels = true;
    applyStudioLabels = [
      "event:studio:create"
      "event:studio:find-unmatched-scenes"
      "plugin:studio:create"
      "event:scene:create"
      "plugin:scene:create"
    ];
    extractSceneActorsFromFilepath = true;
    extractSceneLabelsFromFilepath = true;
    extractSceneMoviesFromFilepath = true;
    extractSceneStudiosFromFilepath = true;
    matcher = {
      type = "word";
      options = {
        ignoreSingleNames = false;
        ignoreDiacritics = true;
        enableWordGroups = true;
        wordSeparatorFallback = true;
        camelCaseWordGroups = true;
        overlappingMatchPreference = "longest";
        groupSeparators = [
          "[\\s',()[\\]{}*\\.]"
        ];
        wordSeparators = [
          "[-_]"
        ];
        filepathSeparators = [
          "[/\\\\&]"
        ];
      };
    };
    matchCreatedActors = true;
    matchCreatedStudios = true;
    matchCreatedLabels = true;
  };
  persistence = {
    backup = {
      enable = true;
      maxAmount = 10;
    };
    libraryPath = "/media/porn-vault/lib";
  };
  plugins = {
    allowActorThumbnailOverwrite = false;
    allowMovieThumbnailOverwrite = false;
    allowSceneThumbnailOverwrite = false;
    allowStudioThumbnailOverwrite = false;
    createMissingActors = false;
    createMissingLabels = false;
    createMissingMovies = false;
    createMissingStudios = false;
    events = {
      actorCreated = [ ];
      actorCustom = [ ];
      sceneCreated = [ ];
      sceneCustom = [ ];
      movieCustom = [ ];
      studioCreated = [ ];
      studioCustom = [ ];
    };
    register = { };
    markerDeduplicationThreshold = 5;
  };
  processing = {
    generatePreviews = true;
    readImagesOnImport = false;
    generateImageThumbnails = true;
  };
  server = {
    https = {
      certificate = "";
      enable = false;
      key = "";
    };
  };
  transcode = {
    hwaDriver = null;
    vaapiDevice = "/dev/dri/renderD128";
    h264 = {
      preset = "veryfast";
      crf = 23;
    };
    webm = {
      deadline = "realtime";
      cpuUsed = 3;
      crf = 31;
    };
  };
}
