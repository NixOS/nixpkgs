{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  finalAttrs = {
    pname = "fm";
    version = "1.2.0";

    src = fetchFromGitHub {
      owner = "mistakenelf";
      repo = "fm";
      rev = "v${finalAttrs.version}";
      hash = "sha256-5+hwubyMgnyYPR7+UdK8VEyk2zo4kniBu7Vj4QarvMg=";
    };

    vendorHash = "sha256-uhrE8ZuUeQSm+Jg1xi83RsBrzjex+aBlElJRT61k0BU=";

    meta = {
      homepage = "https://github.com/mistakenelf/fm";
      description = "Terminal based file manager";
      changelog = "https://github.com/mistakenelf/fm/releases/tag/${finalAttrs.src.rev}";
      license = with lib.licenses; [ mit ];
      mainProgram = "fm";
      maintainers = [ ];
    };
  };
in
buildGoModule finalAttrs
