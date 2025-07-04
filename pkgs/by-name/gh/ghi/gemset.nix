{
  diff-lcs = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sbk0AByMau2ze6GdrsXGNNonsxino8ZUrpeda6GSm2c=";
      type = "gem";
    };
    version = "1.5.0";
  };
  docile = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Xxc0veI3ISRcIMPXI+dsEEII4aoBJ3ppkBzncPDruNM=";
      type = "gem";
    };
    version = "1.4.0";
  };
  ghi = {
    dependencies = [ "pygments.rb" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = ./.;
      type = "path";
    };
    version = "1.2.0";
  };
  hpricot = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3+j0s0FLqDd9diYDDzqmBcqt7p3ofP++rfilA1nqyMo=";
      type = "gem";
    };
    version = "0.8.6";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-thaR/SCHrDcUG3X/QofOLD8XJRxxPpfvc7Q7S7LgNVs=";
      type = "gem";
    };
    version = "2.3.0";
  };
  mustache = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kIkf3VC1ORnKM0yMEDHq2hIV540ibVeV5SPWEjonF9A=";
      type = "gem";
    };
    version = "1.1.1";
  };
  "pygments.rb" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TEHIuu4QaA2Aiy/amyNv5rJ5nNTOXBXim5Ns9L+X9RA=";
      type = "gem";
    };
    version = "2.3.0";
  };
  rake = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XOS/UDe0GWwkrGKDTY2xzhdUcDkQJr2eVX1mm+6xkJc=";
      type = "gem";
    };
    version = "13.0.6";
  };
  rdiscount = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-74hpJt2X1bT/N8gPi6J6eA2VFilGUwO9U9R6lBlyWZs=";
      type = "gem";
    };
    version = "2.2.0.2";
  };
  ronn = {
    dependencies = [
      "hpricot"
      "mustache"
      "rdiscount"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gt9v1KOqkXNIZnENKBGmOH5Qp1E/xSjObH2V7nrX9B4=";
      type = "gem";
    };
    version = "0.7.3";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iQfzLlwwlXJOVMFD6c/E3zcHm+NJND2rkCm+zbJZvqU=";
      type = "gem";
    };
    version = "3.11.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RjF4UDlv6kfmeT3Vp2BsCBaqOPUUn0zV3jCElbibEIU=";
      type = "gem";
    };
    version = "3.11.0";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o8CFmAW9/Yi++QvwUMu0oE8B/p4K0k5bd1ceGr2CMQA=";
      type = "gem";
    };
    version = "3.11.0";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q/vio824y4lNUkQDkrrKYaoOBDtkDj+JY85CbwxraHg=";
      type = "gem";
    };
    version = "3.11.0";
  };
  rspec-support = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AyhKhrdK+73v9sPcGawuD+ZQRTqWuJ+GDUWco+gl03U=";
      type = "gem";
    };
    version = "3.11.0";
  };
  rspec_junit_formatter = {
    dependencies = [ "rspec-core" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vtsX+QcUB4+X//6da7aIGSuoUIH0/mh1vGQnEoz0pOo=";
      type = "gem";
    };
    version = "0.3.0";
  };
  simplecov = {
    dependencies = [
      "docile"
      "simplecov-html"
      "simplecov_json_formatter"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mQ22rttVCG1r+IdJk/8feW5IMKv6EZN0aMpQKg0BO8M=";
      type = "gem";
    };
    version = "0.21.2";
  };
  simplecov-html = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SxqtMyWf+6iynGh2wS23DldQy534KUhuTG5dpPoKoHs=";
      type = "gem";
    };
    version = "0.12.3";
  };
  simplecov_json_formatter = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UpQY++jeFxOsKy1hKqPapW0xaXXTByRDmfpIOMYBtCg=";
      type = "gem";
    };
    version = "0.1.4";
  };
}
