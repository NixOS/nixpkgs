{
  equatable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/chmn5vcmTvly2wI7IY0On6HdW4zxo/19j36qeRPVeo=";
      type = "gem";
    };
    version = "0.5.0";
  };
  httpclient-fixcerts = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VBueQlO9+VDZ7LZkcIR8YEkwHK/DuaURi8iHAqn/2v0=";
      type = "gem";
    };
    version = "2.8.5";
  };
  necromancer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-f6t7xGWmNDZdNUNBoPelemkot7Bnd0QsOzd/s2eDNm0=";
      type = "gem";
    };
    version = "0.4.0";
  };
  neocities = {
    dependencies = [
      "httpclient-fixcerts"
      "pastel"
      "rake"
      "tty-prompt"
      "tty-table"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fH3FQVsjAmsmdDILkSu8tcSPndAyrybom/3nwx7x28E=";
      type = "gem";
    };
    version = "0.0.18";
  };
  pastel = {
    dependencies = [
      "equatable"
      "tty-color"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4dId2PuWXlBS0bFhZKd3/EUMbhh78Zn4M6neP1MDw/k=";
      type = "gem";
    };
    version = "0.7.2";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-92lK20/mONo1RSMAzubFRenDd6DjGQAYrATVkLPCarM=";
      type = "gem";
    };
    version = "12.3.3";
  };
  strings = {
    dependencies = [
      "strings-ansi"
      "unicode-display_width"
      "unicode_utils"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4LM5u3ubHINELcJ4IjBNMptmAM3z/8PBgNNnzKg5KIQ=";
      type = "gem";
    };
    version = "0.1.8";
  };
  strings-ansi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kCYtdg6kqUzCro1YIFJ3o0NAnCiMvnwpQWsYJr1RHIg=";
      type = "gem";
    };
    version = "0.2.0";
  };
  tty-color = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cx0N0C2pxjrKEmABFTRA34lx/ukWNTIGTEbm1Y3q5X8=";
      type = "gem";
    };
    version = "0.4.3";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SgjUp6iQVL9fOItjDZIaGGtodfBYVCZ0IvRcW1F1kB8=";
      type = "gem";
    };
    version = "0.4.0";
  };
  tty-prompt = {
    dependencies = [
      "necromancer"
      "pastel"
      "tty-cursor"
      "wisper"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YN8ZgCPccgC48UhLHW8u/h2gGByzo1mtiP3VB7G3RoA=";
      type = "gem";
    };
    version = "0.12.0";
  };
  tty-screen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gWs0ggVMX/eBsSMoUsjzqIv12sCZpW7pYh7VBv2T9ys=";
      type = "gem";
    };
    version = "0.6.5";
  };
  tty-table = {
    dependencies = [
      "equatable"
      "necromancer"
      "pastel"
      "strings"
      "tty-screen"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j33Jv8P/vqRTu5wwKtNK3IQRss5fq0vOX67e0oPMeRY=";
      type = "gem";
    };
    version = "0.10.0";
  };
  unicode-display_width = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ApITLTZNWfzdg/FEkQxIs8gzKyihTFwEuwk90WVgBIg=";
      type = "gem";
    };
    version = "1.8.0";
  };
  unicode_utils = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uSLQzyMTtrcTatpmRc5xVP/IZBjKB9U7BY7+nrcvKkA=";
      type = "gem";
    };
    version = "1.4.0";
  };
  wisper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WuiKSqjKtU7ISak0xOcK6771YBFN0WTf2bAFjsMHfKU=";
      type = "gem";
    };
    version = "1.6.1";
  };
}
