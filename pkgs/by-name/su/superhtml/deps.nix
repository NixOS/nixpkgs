{
  linkFarm,
  fetchzip,
  fetchgit,
}:
linkFarm "zig-packages" [
  {
    name = "1220b9ce6dc0e1fbcd9e7b406ab164344f81774351495f860a90729187c3c058ef4f";
    path = fetchgit {
      url = "https://github.com/kristoff-it/zig-lsp-kit";
      rev = "b4bf61d7fbf9cf7cfdb6f01b211947d2de3e42fd";
      hash = "sha256-6mlnPTLBXZQwWXstV+h1PAKtMq8RGcJM2dRJ8NqqqtU=";
    };
  }
  {
    name = "1220102cb2c669d82184fb1dc5380193d37d68b54e8d75b76b2d155b9af7d7e2e76d";
    path = fetchzip {
      url = "https://github.com/ziglibs/diffz/archive/ef45c00d655e5e40faf35afbbde81a1fa5ed7ffb.tar.gz";
      hash = "sha256-5/3W0Xt9RjsvCb8Q4cdaM8dkJP7CdFro14JJLCuqASo=";
    };
  }
  {
    name = "12209cde192558f8b3dc098ac2330fc2a14fdd211c5433afd33085af75caa9183147";
    path = fetchgit {
      url = "https://github.com/ziglibs/known-folders.git";
      rev = "0ad514dcfb7525e32ae349b9acc0a53976f3a9fa";
      hash = "sha256-X+XkFj56MkYxxN9LUisjnkfCxUfnbkzBWHy9pwg5M+g=";
    };
  }
  {
    name = "122014e78d7c69d93595993b3231f3141368e22634b332b0b91a2fb73a8570f147a5";
    path = fetchgit {
      url = "https://github.com/kristoff-it/scripty";
      rev = "df8c11380f9e9bec34809f2242fb116d27cf39d6";
      hash = "sha256-qVm8pIfT1mHL1zanqYdFm/6AVH8poXKqLtz4+2j+F/A=";
    };
  }
  {
    name = "1220f2d8402bb7bbc4786b9c0aad73910929ea209cbd3b063842371d68abfed33c1e";
    path = fetchgit {
      url = "https://github.com/kristoff-it/zig-afl-kit";
      rev = "f003bfe714f2964c90939fdc940d5993190a66ec";
      hash = "sha256-tJ6Ln1SY4WjFZXUWQmgggsUfkd59QgmIpgdInMuv4PI=";
    };
  }
  {
    name = "1220010a1edd8631b2644476517024992f8e57f453bdb68668720bb590d168faf7c8";
    path = fetchgit {
      url = "https://github.com/allyourcodebase/AFLplusplus";
      rev = "032984eabf5a35af386a3d0e542df7686da339c1";
      hash = "sha256-KB3QnKAQQ+5CKvJVrhMveMGpF3NTrlwpIyLHVIB96hs=";
    };
  }
  {
    name = "12200966011c3dd6979d6aa88fe23061fdc6da1f584a6fb1f7682053a0b01e409dbc";
    path = fetchzip {
      url = "https://github.com/AFLplusplus/AFLplusplus/archive/v4.21c.tar.gz";
      hash = "sha256-DKwPRxSO+JEJYWLldnfrAYqzwqukNzrbo4R5FzJqzzg=";
    };
  }
]
