{
  services.liberaforms = {
    enable = true;
    openPorts = true;

    reverseProxy = {
      enable = true;
      ssl = false;
      host = "liberaforms.test";
      webserver.nginx = { };
    };

    settings = {
      ROOT_USER = "ngi@nixos.org";
      SECRET_KEY = "a_secret_key";
      SESSION_TYPE = "filesystem";
      TOKEN_EXPIRATION = 604800;
      DEFAULT_TIMEZONE = "Asia/Shanghai";
      TOTAL_UPLOADS_LIMIT = "1 GB";
      DEFAULT_USER_UPLOADS_LIMIT = "50 MB";
      ENABLE_REMOTE_STORAGE = false;
      MAX_MEDIA_SIZE = 512000;
      MAX_ATTACHMENT_SIZE = 1572864;
      ENABLE_PROMETHEUS_METRICS = false;
      ENABLE_RSS_FEED = false;
      DEFAULT_LANGUAGE = "en-US";
    };
  };

  networking.extraHosts = ''
    127.0.0.1 liberaforms.test
  '';
}
