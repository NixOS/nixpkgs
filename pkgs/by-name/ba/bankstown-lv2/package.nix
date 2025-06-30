{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bankstown-lv2";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "chadmed";
    repo = "bankstown";
    rev = finalAttrs.version;
    hash = "sha256-IThXEY+mvT2MCw0PSWU/182xbUafd6dtm6hNjieLlKg=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "target/release" \
                     "target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType"
  '';

  cargoHash = "sha256-eMN95QNnQtC7QDix9g3dwb9ZbtQuiVBj8+R+opFs0KI=";

  dontCargoInstall = true;

  installFlags = [
    "DESTDIR=$(out)"
    "LIBDIR=lib"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/chadmed/bankstown";
    description = "Lightweight psychoacoustic bass enhancement plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      normalcea
      yuka
    ];
    platforms = lib.platforms.linux;
  };
})
