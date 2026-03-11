{
  lib,
  fetchFromGitHub,
  libgit2,
  kdePackages,
  stdenv,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kraft-invoicing";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "dragotin";
    repo = "kraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eDd7Bg8CC4bxrlEvHFLGKbbM42eNNKTYKQCBQf+Typ4=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
  ];

  buildInputs =
    with kdePackages;
    [
      extra-cmake-modules
      kio
      kidletime
      kxmlgui
      kcmutils
      libplasma
      plasma5support
      kcontacts
      ktexttemplate
      akonadi
      akonadi-contacts
    ]
    ++ [ libgit2 ];

  meta = {
    license = lib.licenses.gpl2Plus;
    homepage = "https://volle-kraft-voraus.de";
    description = "Kraft helps to handle your daily quotes and invoices in your small business.";
    maintainers = [ lib.maintainers.dshatz ];
    mainProgram = "kraft";
  };
})
