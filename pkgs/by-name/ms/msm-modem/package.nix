{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  nix-update-script,
  makeWrapper,
  gnugrep,
  gawk,
  libqmi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msm-modem";
  version = "13";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "msm-modem";
    tag = finalAttrs.version;
    hash = "sha256-kKDqYrd7yI3beS7kMVN+xqTBfNC4NTUgch2t/rDM9LE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    makeWrapper
  ];

  mesonFlags = [
    "-Ddownstream=false"
    "-Dopenrc=false"
  ];

  postInstall = ''
    wrapProgram $out/libexec/msm-modem-uim-selection \
        --prefix PATH : ${
          lib.makeBinPath [
            libqmi
            gawk
            gnugrep
          ]
        }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Common support for Qualcomm MSM modems";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/msm-modem";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    platforms = lib.platforms.linux;
  };
})
