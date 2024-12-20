{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "livedl";
  version = "unstable-2021-05-16";

  src = fetchFromGitHub {
    owner = "himananiito";
    repo = pname;
    rev = "a8720f1e358e5b0ade6fdeb8aacc00781e6cc504";
    sha256 = "1zax215jp6sl47m8ahssyyrbzn96dh74srq9g61jc76sq10xg329";
  };

  modRoot = "src";

  proxyVendor = true;
  vendorHash = "sha256-C7lUusq/cWBCnA2wP9fzQglJCXvQyvFG4JY13H0cP6g=";

  meta = with lib; {
    description = "Command-line tool to download nicovideo.jp livestreams";
    homepage = "https://github.com/himananiito/livedl";
    license = licenses.mit;
    maintainers = with maintainers; [ wakira ];
    platforms = platforms.linux ++ platforms.darwin;
    broken = stdenv.hostPlatform.isDarwin; # build fails with go > 1.17
    mainProgram = "livedl";
  };
}
