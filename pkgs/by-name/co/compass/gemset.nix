{
  chunky_png = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1znw5x86hmm9vfhidwdsijz8m38pqgmv98l9ryilvky0aldv7mc9";
      type = "gem";
    };
    version = "1.4.0";
  };
  compass = {
    dependencies = [
      "chunky_png"
      "compass-core"
      "compass-import-once"
      "rb-fsevent"
      "rb-inotify"
      "sass"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lfi83w8z75czr0pf0rmj9hda22082h3cmvczl8r1ma9agf88y2c";
      type = "gem";
    };
    version = "1.0.3";
  };
  compass-core = {
    dependencies = [
      "multi_json"
      "sass"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yaspqwdmzwdcqviclbs3blq7an16pysrfzylz8q1gxmmd6bpj3a";
      type = "gem";
    };
    version = "1.0.3";
  };
  compass-import-once = {
    dependencies = [ "sass" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bn7gwbfz7jvvdd0qdfqlx67fcb83gyvxqc7dr9fhcnks3z8z5rq";
      type = "gem";
    };
    version = "1.0.5";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19kdyjg3kv7x0ad4xsd4swy5izsbb1vl1rpb6qqcqisr5s23awi9";
      type = "gem";
    };
    version = "1.17.2";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06sabsvnw0x1aqdcswc6bqrqz6705548bfd8z22jxgxfjrn1yn3n";
      type = "gem";
    };
    version = "1.17.0";
  };
  rb-fsevent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vmy8xgahixcz6hzwy4zdcyn2y6d6ri8dqv5xccgzc1r292019x0";
      type = "gem";
    };
    version = "0.11.1";
  };
  sass = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kfpcwh8dgw4lc81qglkvjl73689jy3g7196zkxm4fpskg1p5lkw";
      type = "gem";
    };
    version = "3.4.25";
  };
}
