{
  bindata = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KdzLi6HMneFI8ku4iTCEDGLbVnFfD4Dsyt1iTZ89JiM=";
      type = "gem";
    };
    version = "2.5.0";
  };
  elftools = {
    dependencies = [ "bindata" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0Xx0g8IhOX+64UTILZBbc5FSwCgfUd992k6Pr4nkJl0=";
      type = "gem";
    };
    version = "1.1.3";
  };
  one_gadget = {
    dependencies = [ "elftools" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vJ7Ipidqbn/0XRWkSC+Ewh91hkd7aCcwLFUmkSA6JMk=";
      type = "gem";
    };
    version = "1.9.0";
  };
}
