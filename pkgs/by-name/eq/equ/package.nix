{
  lib,
  buildGoModule,
  fetchFromGitLab,
  makeBinaryWrapper,
  zlib,
  xorg,
  fontconfig,
}:

buildGoModule (finalAttrs: {
  pname = "equ";
  version = "1.2.5";

  src = fetchFromGitLab {
    owner = "cznic";
    repo = "equ";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+BCsJhXJgJc++9W4kf4xI6XwSV91R+jxqPOoRH9bd48=";
  };

  vendorHash = "sha256-I2yLiT1vYvv7x/lfsWp/5A/8800DNSKx8fRk6XeMmnk=";

  # From some reason, wrapping is needed for the GUI - the Go package doesn't
  # seem to demand these packages automatically.
  nativeBuildInputs = [
    makeBinaryWrapper
  ];
  postInstall = ''
    wrapProgram "$out/bin/equ" --prefix LD_LIBRARY_PATH ":" ${
      lib.makeLibraryPath [
        zlib
        xorg.libXft
        fontconfig.lib
        xorg.libX11.out
      ]
    }
  '';

  meta = {
    description = "Plain TeX math editor";
    homepage = "https://gitlab.com/cznic/equ";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "equ";
  };
})
