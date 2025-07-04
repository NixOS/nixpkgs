{
  colorize = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-C6DCpYIy+bcG3DBiHqaqZGju6hIOtvHMxAAQW5DEeYw=";
      type = "gem";
    };
    version = "0.8.1";
  };
  commander = {
    dependencies = [ "highline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fR3cP8yuYMyQa0ExuRYQfi7wEIhY9IX92jBhDA8pE9k=";
      type = "gem";
    };
    version = "4.6.0";
  };
  diffy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QmS559sA0c1Cb80y42Vld5FjztwjQKlbDm8CXnH5qqc=";
      type = "gem";
    };
    version = "3.4.3";
  };
  highline = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ld1cEn1GknIUhvkXNzByNv4AU1LRKkIC4mxIYU9xlHk=";
      type = "gem";
    };
    version = "2.0.3";
  };
  polyglot = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WdZu9ePBZkMcOcuLfB0Cr0GQUTUvJ5EvakOYGz3vFq8=";
      type = "gem";
    };
    version = "0.3.5";
  };
  terraform_landscape = {
    dependencies = [
      "colorize"
      "commander"
      "diffy"
      "treetop"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Glk0m4CbGgl1WXqo8drEwGjkdjVn6+T7NFFMZLXCmtE=";
      type = "gem";
    };
    version = "0.3.4";
  };
  treetop = {
    dependencies = [ "polyglot" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ujHRkRzlPbxoIIuea0IdSNFr/JlVHl77W8cbvI/HrtQ=";
      type = "gem";
    };
    version = "1.6.14";
  };
}
