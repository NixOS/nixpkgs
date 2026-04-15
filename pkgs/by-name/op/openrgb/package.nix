{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  libusb1,
  hidapi,
  pkg-config,
  coreutils,
  makeBinaryWrapper,
  mbedtls,
  symlinkJoin,
  qt6Packages,
  autoAddDriverRunpath,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openrgb";
  version = "1.0rc2";

  src = fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    tag = "release_candidate_${finalAttrs.version}";
    hash = "sha256-vdIA9i1ewcrfX5U7FkcRR+ISdH5uRi9fz9YU5IkPKJQ=";
  };

  patches = [
    ./system-plugins-env.patch
    (fetchpatch {
      name = "Install-systemd-service-under-PREFIX.patch";
      url = "https://gitlab.com/CalcProgrammer1/OpenRGB/-/commit/b58b3c0402131918b3b988631f42617020df9346.patch";
      hash = "sha256-q5i5BNjaLbsXSYEXKQOR/cMm5ExckmW1n2r9H0j09T0=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoAddDriverRunpath
  ]
  ++ (with qt6Packages; [
    qmake
    wrapQtAppsHook
  ]);

  buildInputs = [
    libusb1
    hidapi
    mbedtls
  ]
  ++ (with qt6Packages; [
    qtbase
    qttools
    qtwayland
  ]);

  postPatch = ''
    patchShebangs scripts/build-udev-rules.sh
    substituteInPlace scripts/build-udev-rules.sh \
      --replace-fail '/usr/bin/env chmod' ${lib.getExe' coreutils "chmod"}
  '';

  postInstall = ''
    substituteInPlace "$out/lib/systemd/system/openrgb.service" \
      --replace-fail /usr/bin/openrgb "$out/bin/openrgb"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    HOME=$TMPDIR $out/bin/openrgb --help > /dev/null

    if grep -R /usr/bin/env "$out/lib/udev/rules.d"; then
      echo "Error: udev rules must not reference /usr/bin/env"
      exit 1
    fi

    runHook postInstallCheck
  '';

  qmakeFlags = [
    "QT_TOOL.lrelease.binary=${lib.getDev qt6Packages.qttools}/bin/lrelease"
  ];

  passthru.withPlugins =
    plugins:
    symlinkJoin {
      inherit (finalAttrs) version meta;
      pname = finalAttrs.pname + "-with-plugins";
      nativeBuildInputs = [ makeBinaryWrapper ];
      paths = [ finalAttrs.finalPackage ] ++ plugins;
      postBuild = ''
        wrapProgram "$out/bin/openrgb" \
          --set OPENRGB_SYSTEM_PLUGIN_DIRECTORY "$out/lib/openrgb/plugins"

        # Update systemd service to use wrapped package
        service_file="$out/lib/systemd/system/openrgb.service"
        substitute "$service_file" openrgb.service \
          --replace-fail ${finalAttrs.finalPackage} "$out"
        mv --force openrgb.service "$service_file"

        # Check for unhandled references to the base package
        if grep \
            --dereference-recursive \
            --binary-files=without-match \
            --fixed-strings \
             ${finalAttrs.finalPackage} \
             "$out"
        then
          echo "ERROR: unexpected reference to base package"
          exit 1
        fi
      '';
    };

  meta = {
    description = "Open source RGB lighting control";
    homepage = "https://gitlab.com/CalcProgrammer1/OpenRGB";
    maintainers = with lib.maintainers; [ johnrtitor ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "openrgb";
  };
})
