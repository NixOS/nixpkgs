{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gjo";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "gjo";
    rev = finalAttrs.version;
    hash = "sha256-vEk5MZqwAMgqMLjwRJwnbx8nVyF3U2iUz0S3L0GmCh4=";
  };

  vendorHash = null;

  meta = {
    description = "Small utility to create JSON objects";
    mainProgram = "gjo";
    homepage = "https://github.com/skanehira/gjo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
