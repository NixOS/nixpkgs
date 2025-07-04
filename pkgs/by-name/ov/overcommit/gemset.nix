{
  childprocess = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mo1IS+L9QJag6QoM0+RJoFvDqjP4rJ5Nbc72rBRVtuw=";
      type = "gem";
    };
    version = "5.1.0";
  };
  iniparse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NqFl6Y2KJQt2McSn+a+6Mq948ImXDNZEajl3EYnHYfE=";
      type = "gem";
    };
    version = "1.5.0";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OtlYftOUC/eJfqZKZzlxQVUj9PfWsixeOvUhlwVmllM=";
      type = "gem";
    };
    version = "1.6.1";
  };
  overcommit = {
    dependencies = [
      "childprocess"
      "iniparse"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-myQPmRT6aF4nFd3LLMFQtoVRnXRZk6W5r5rjLO8N9FI=";
      type = "gem";
    };
    version = "0.64.0";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YqOk0ois4YgwrWyoq6hFA30jHE+MtIG6Jwyht1tgUCc=";
      type = "gem";
    };
    version = "3.3.7";
  };
}
