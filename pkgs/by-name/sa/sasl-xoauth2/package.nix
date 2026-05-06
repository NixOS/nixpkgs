{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  cyrus_sasl,
  gitUpdater,
  jsoncpp,
  makeWrapper,
  pandoc,
  pkg-config,
  python3,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      argparse-manpage
      msal
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sasl-xoauth2";
  version = "0.27";

  src = fetchFromGitHub {
    owner = "tarickb";
    repo = "sasl-xoauth2";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-GUdt39DNtYZl4qsnhnWufXOgu5Mg1+HCJap8IfFyldk=";
  };

  # Let sasl-xoauth2 find configuration files in /etc
  postPatch = ''
    substituteInPlace src/CMakeLists.txt scripts/sasl-xoauth2-tool.in \
      --replace-fail "\''${CMAKE_INSTALL_FULL_SYSCONFDIR}" '/etc'

    substituteInPlace scripts/sasl-xoauth2-tool.in \
      --replace-fail '#!/usr/bin/python3' '#!${lib.getExe python3}'
  '';

  nativeBuildInputs = [
    cmake
    curl
    makeWrapper
    pandoc
    pkg-config
  ];

  buildInputs = [
    cyrus_sasl
    jsoncpp
  ];

  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : "${pythonEnv}/bin" \
      --set PYTHONPATH "$out/share/:${pythonEnv}/${python3.sitePackages}"
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "release-"; };

  meta = {
    homepage = "https://github.com/tarickb/sasl-xoauth2";
    changelog = "https://github.com/tarickb/sasl-xoauth2/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "SASL plugin for XOAUTH2";
    platforms = lib.platforms.linux;
    mainProgram = "sasl-xoauth2-tool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ codgician ];
  };
})
