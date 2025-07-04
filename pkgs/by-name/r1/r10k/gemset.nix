{
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  colored2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sTwr1+6uLPc1amJQHTmOcv3nh4C9Jq7GqXlXgpPCi0o=";
      type = "gem";
    };
    version = "3.1.2";
  };
  cri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ir/pJO9T53Ko5O6QfnkdO/z8p4vGKlhZ47mJm6KZVuU=";
      type = "gem";
    };
    version = "2.15.12";
  };
  erubi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/KYbR9rv2GXQ+1DRaGNPJ61AGBhnRFut9kJ8RZwzzWI=";
      type = "gem";
    };
    version = "1.13.0";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-a8n7o/YZFoREnZQhUZWyxD4qB71AsyHSRYgUUJI9moA=";
      type = "gem";
    };
    version = "2.10.1";
  };
  faraday-follow_redirects = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2S2XVjXix/5SXdSU/NS5u38KSg7A1fTBXHKVMP24B/k=";
      type = "gem";
    };
    version = "0.3.0";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2pPw9Cb03iwJrwqalYh3Jtp4ibduyioq/wzl5m52iTg=";
      type = "gem";
    };
    version = "3.1.1";
  };
  fast_gettext = {
    dependencies = [ "prime" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/SbExAaqEL408P0oR84//cHp2XmN6HU4WUdXu7kXX78=";
      type = "gem";
    };
    version = "2.4.0";
  };
  forwardable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8X30vWr6b0agAyFwI/5XFu+IziYfXEzw7b3u1kcMr6w=";
      type = "gem";
    };
    version = "1.3.3";
  };
  gettext = {
    dependencies = [
      "erubi"
      "locale"
      "prime"
      "racc"
      "text"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KShk/moVwiTO5BJaSnL6tCb9uygOTP88/kSTX1SbAJo=";
      type = "gem";
    };
    version = "3.4.9";
  };
  gettext-setup = {
    dependencies = [
      "fast_gettext"
      "gettext"
      "locale"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KtT6mVddhp8YBWlB2Y3Jyyplarx7mR82D70+MtKP1Ow=";
      type = "gem";
    };
    version = "1.1.0";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Wph3MV4iTVUXhVYIcChyZwiO7f7ALVI5Zk3vFI0YvBI=";
      type = "gem";
    };
    version = "2.8.2";
  };
  locale = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ui+Zc+8+7mSqybygbSHbL7pnX6PSz2HSH0LRyhip94A=";
      type = "gem";
    };
    version = "2.1.4";
  };
  log4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-m0UpKMlkt8VMCa6yX/BFtacis4exbJzjfLG67AAGKWY=";
      type = "gem";
    };
    version = "1.1.10";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CrfBICYt2N4qGMuNN38fMYy+mFNRYKUIr553EP9D7z4=";
      type = "gem";
    };
    version = "1.6.0";
  };
  minitar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Oh27roxMjmerjjlRujbLk7hEwiWyn4PjuQ9IIm89YDg=";
      type = "gem";
    };
    version = "0.12.1";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qW78XqGLy5cV4k3aQVnRD2f/A0XIqYDQRjACgFWywoI=";
      type = "gem";
    };
    version = "0.4.1";
  };
  prime = {
    dependencies = [
      "forwardable"
      "singleton"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1OlWyt+vBN4DbcfcdPlb9qKFpizFCbKLemayRdGf46Q=";
      type = "gem";
    };
    version = "0.1.2";
  };
  puppet_forge = {
    dependencies = [
      "faraday"
      "faraday-follow_redirects"
      "minitar"
      "semantic_puppet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BjjHsjFl4GQedO3RGph32TTsfnsxljgjgvdWG2L+xTQ=";
      type = "gem";
    };
    version = "5.0.4";
  };
  r10k = {
    dependencies = [
      "colored2"
      "cri"
      "gettext-setup"
      "jwt"
      "log4r"
      "minitar"
      "multi_json"
      "puppet_forge"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZOW54abLtABslkd9jDTOWJ/hwngRcxH0UtnzC5zIbkw=";
      type = "gem";
    };
    version = "4.1.0";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  semantic_puppet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UtEI0I4aXZXAA0PLOkk2+x3uz/K+YS7DnJy2a+WouFk=";
      type = "gem";
    };
    version = "1.1.0";
  };
  singleton = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pstzBEIWhNgAk4Wa7TiyYDX25Uo4w+T+ZFbPtWskBWM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  text = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L7u8gsHOecQZWxMBiofLsA12K9o5JBuzzcMnknWd0/Q=";
      type = "gem";
    };
    version = "1.3.1";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JlU8KpOZdi4ei+vUREtDYcSyEpjPHIZLIu6rycSZjyQ=";
      type = "gem";
    };
    version = "0.13.0";
  };
}
