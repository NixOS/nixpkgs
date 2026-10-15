{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule {
  pname = "livedl";
  version = "unstable-2021-05-16";

  src = fetchFromGitHub {
    owner = "himananiito";
    repo = "livedl";
    rev = "a8720f1e358e5b0ade6fdeb8aacc00781e6cc504";
    hash = "sha256-SYzXQcDaHCaDeQlnTQ5sJtm/svdaQ4XqIVSbK0sQXf0=";
  };

  modRoot = "src";

  proxyVendor = true;
  vendorHash = "sha256-C7lUusq/cWBCnA2wP9fzQglJCXvQyvFG4JY13H0cP6g=";

  meta = {
    description = "Command-line tool to download nicovideo.jp livestreams";
    homepage = "https://github.com/himananiito/livedl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wakira ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    broken = stdenv.hostPlatform.isDarwin; # build fails with go > 1.17
    mainProgram = "livedl";
  };
}
