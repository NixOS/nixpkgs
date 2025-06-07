{
  fetchFromGitHub,
  fetchNuGet,
  glib,
  gtk-sharp-2_0,
  lib,
  makeWrapper,
  mono,
  pkg-config,
  stdenv,
}:

let
  nunit = fetchNuGet {
    pname = "NUnit";
    version = "3.13.1";
    hash = "sha256-qdbPWgCXueQdHpGdNQtdz16Zfg+XESI9xDlRD/IzJRw=";
    outputFiles = [ "lib/*" ];
  };

  nunit3 = nunit.overrideAttrs (_: {
    postInstall = ''
      mkdir -p $out/lib/pkgconfig

      cat > $out/lib/pkgconfig/nunit.framework.pc  << EOF
      Libraries=$out/lib/dotnet/NUnit/net45/nunit.framework.dll

      Name: nunit.framework
      Description: nunit.framework
      Version: 3.13.1
      Libs: -r:nunit.framework.dll

      EOF
    '';
  });

  resources = fetchFromGitHub {
    owner = "renode";
    repo = "renode-resources";
    rev = "d3d69f8f17ed164ee23e46f0c06844a69bf4c004";
    hash = "sha256-wR3heL58NOQLENwCzL4lPM4KuvT/ON7dlc/KUqrlRjg=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renode";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sZhO332seVPuYhk6Cx5UEPyGWfN9TkuavvpVyLJU2Sw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs build.sh tools/
  '';

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    mono
    pkg-config
  ];

  buildInputs = [
    gtk-sharp-2_0
    nunit3
  ];

  preBuild = ''
    mkdir -p lib/resources/
    ln -s ${resources}/* lib/resources/

    chmod +x build.sh tools/building/check_weak_implementations.sh
  '';

  postBuild = "./build.sh";

  postInstall = ''
    mkdir -p $out/{bin,lib/renode}

    mv output/bin/Release/* .renode-root $out/lib/renode

    makeWrapper ${mono}/bin/mono $out/bin/renode \
      --add-flags "$out/lib/renode/Renode.exe" \
      --prefix MONO_GAC_PREFIX : ${gtk-sharp-2_0} \
      --suffix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          glib
          gtk-sharp-2_0
          gtk-sharp-2_0.gtk
        ]
      }"
  '';

  meta = {
    changelog = "https://github.com/renode/renode/blob/${finalAttrs.version}/CHANGELOG.rst";
    description = "Virtual development framework for complex embedded systems";
    downloadPage = "https://github.com/renode/renode";
    homepage = "https://renode.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      otavio
    ];
    platforms = [ "x86_64-linux" ];
  };
})
