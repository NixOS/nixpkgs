{
  lib,
  fetchurl,
  rustPlatform,
  libfaketime,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nmstate";
  version = "2.2.60";

  srcs = [
    (fetchurl {
      url = "https://github.com/nmstate/nmstate/releases/download/v${finalAttrs.version}/nmstate-${finalAttrs.version}.tar.gz";
      hash = "sha256-k8FXwnuSKWjfxuj2SbrLAChzA+D9g7E88f8VqY+zWZw=";
    })
    (fetchurl {
      url = "https://github.com/nmstate/nmstate/releases/download/v${finalAttrs.version}/nmstate-vendor-${finalAttrs.version}.tar.xz";
      hash = "sha256-8NxAX3mPZ3z3u6vU/ddAotXmgLfLCRwukc6J3FzxhKY=";
    })
  ];
  sourceRoot = ".";
  postUnpack = ''
    mv nmstate-* source
    mv vendor source/rust/
    cd source
  '';

  postPatch = ''
    substituteInPlace packaging/nmstate.service --replace-fail /usr/bin $out/bin
  '';

  cargoRoot = "rust";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoVendorDir = "vendor";

  nativeBuildInputs = [
    libfaketime
  ];

  postInstall = ''
    ln -s ../target rust/target
    source_date=$(date --utc --date=@$SOURCE_DATE_EPOCH "+%F %T")
    PREFIX=$out LIBDIR=$out/lib RELEASE=1 SKIP_PYTHON_INSTALL=1 faketime -f "$source_date" make install
  '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "Nmstate: A Declarative Network API";
    homepage = "https://nmstate.io/";
    changelog = "https://github.com/nmstate/nmstate/blob/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.asl20;
    mainProgram = "nmstatectl";
    maintainers = with lib.maintainers; [
      iwanb
    ];
    platforms = with lib.platforms; unix;
  };
})
