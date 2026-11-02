{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  pandoc,
  curl,
  jsoncpp,
  cyrus_sasl,
  argparse-manpage,
  python3,
  makeWrapper,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.msal
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sasl-xoauth2";
  version = "0.28";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tarickb";
    repo = "sasl-xoauth2";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-u8bbaLHw/m7wWpzKmpSFMYHRCeigAiJ2EOUMaKsN1BQ=";
  };

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCMAKE_INSTALL_SYSCONFDIR=/etc"
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'DESTINATION ''${CMAKE_INSTALL_SYSCONFDIR}' 'DESTINATION share/doc/sasl-xoauth2'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    pandoc
    argparse-manpage
    makeWrapper
    pythonEnv
  ];

  buildInputs = [
    curl
    jsoncpp
    cyrus_sasl
  ];

  postInstall = ''
    wrapProgram $out/bin/sasl-xoauth2-tool \
      --prefix PYTHONPATH : "${pythonEnv}/${pythonEnv.python.sitePackages}"
  '';

  meta = {
    description = "SASL plugin for XOAUTH2";
    homepage = "https://github.com/tarickb/sasl-xoauth2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dshatz ];
    mainProgram = "sasl-xoauth2-tool";
  };
})
