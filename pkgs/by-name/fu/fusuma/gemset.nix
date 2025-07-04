{
  fusuma = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tcyrRk5QhlcLj3vdONzsg9Z9F+HLdlUcNY8ZXN6QFME=";
      type = "gem";
    };
    version = "3.7.0";
  };
  fusuma-plugin-appmatcher = {
    dependencies = [
      "fusuma"
      "rexml"
      "ruby-dbus"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GPZrYHQNP8AobV060dERy9tTVC6bo/muqr3J8X1oQ7I=";
      type = "gem";
    };
    version = "0.7.1";
  };
  fusuma-plugin-keypress = {
    dependencies = [ "fusuma" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NBrLjKexZ+w5gAbjtC4Y2XntTvGLFUP3Qiv5koxsmpk=";
      type = "gem";
    };
    version = "0.11.0";
  };
  fusuma-plugin-sendkey = {
    dependencies = [
      "fusuma"
      "revdev"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-95L+wZS2EdXXm5O2aUh2KSxDvuVWNdlCL4hbZQnut2U=";
      type = "gem";
    };
    version = "0.10.1";
  };
  fusuma-plugin-wmctrl = {
    dependencies = [ "fusuma" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Bnk5sti5nPj85DvkA0HNo94zcVlqik+yTrE8qEwL/+U=";
      type = "gem";
    };
    version = "1.3.1";
  };
  revdev = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6euLAV0BiWNwUMNzQq1sz02LSYOd9Y7dCDMqird536w=";
      type = "gem";
    };
    version = "0.2.1";
  };
  rexml = {
    dependencies = [ "strscan" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CQioY4HZ+XOCRoDfTgp1QidmJy8DscDknbfnnCPbETU=";
      type = "gem";
    };
    version = "3.2.8";
  };
  ruby-dbus = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9YLaCmbnqQfa3pRzwVIZQZfjIuUHcSdYU6yHuGjxyUE=";
      type = "gem";
    };
    version = "0.23.1";
  };
  strscan = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AbioHSFPv3tTCMb7UbWXK7/EpqofFm/TYYupfg/NVVU=";
      type = "gem";
    };
    version = "3.1.0";
  };
}
