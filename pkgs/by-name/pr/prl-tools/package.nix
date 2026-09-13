{
  autoPatchelfHook,
  bash,
  bbe,
  coreutils,
  cups,
  dbus,
  fetchurl,
  fuse3,
  gawk,
  glib,
  gnugrep,
  gnused,
  gtk3,
  lib,
  makeWrapper,
  netcat,
  p7zip,
  stdenv,
  timetrap,
  undmg,
  util-linux,
  wayland,
  libxrandr,
}:

let
  libPath = lib.concatStringsSep ":" [
    "${glib.out}/lib"
    "${libxrandr}/lib"
    "${wayland.out}/lib"
  ];
  scriptPath = lib.concatStringsSep ":" [
    "${bash}/bin"
    "${coreutils}/bin"
    "${cups}/sbin"
    "${gawk}/bin"
    "${gnugrep}/bin"
    "${gnused}/bin"
    "${netcat}/bin"
    "${timetrap}/bin"
    "${util-linux}/bin"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prl-tools";
  version = "27.0.1-58670";

  # We download the full distribution to extract prl-tools-lin.iso from
  # => ${dmg}/Parallels\ Desktop.app/Contents/Resources/Tools/prl-tools-lin.iso
  src = fetchurl {
    url = "https://download.parallels.com/desktop/v${lib.versions.major finalAttrs.version}/${finalAttrs.version}/ParallelsDesktop-${finalAttrs.version}.dmg";
    hash = "sha256-Qkul+hZh0J7g8+D+T7RLmfrtK2i90+wlsrfm5tNaYug=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    bbe
    makeWrapper
    p7zip
    undmg
  ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  runtimeDependencies = [
    dbus.lib
    fuse3.out # prl_fsd dlopens libfuse3.so.3 or libfuse3.so.4
    glib.out
    gtk3.out
    libxrandr
  ];

  unpackPhase = ''
    runHook preUnpack

    undmg $src
    export sourceRoot=prl-tools-build
    7z x "Parallels Desktop.app/Contents/Resources/Tools/prl-tools-lin${lib.optionalString stdenv.hostPlatform.isAarch64 "-arm"}.iso" -o$sourceRoot
    runHook postUnpack
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    ( # tools
      cd tools/tools${
        if stdenv.hostPlatform.isAarch64 then
          "-arm64"
        else if stdenv.hostPlatform.isx86_64 then
          "64"
        else
          "32"
      }

      # prltoolsd executes /bin/bash with /bin/sh as its upstream fallback.
      # Use /bin/sh directly, including in its SHELL environment entry.
      bbe -e "s:/bin/bash:/bin/sh\x00\x00:" -o bin/prltoolsd.tmp bin/prltoolsd
      mv bin/prltoolsd.tmp bin/prltoolsd

      # replace hardcoded /usr/bin/prl_fsd
      substituteInPlace ../mount.fuse.prl_fsd \
        --replace-fail "/usr/bin/prl_fsd" "$out/bin/prl_fsd"

      # NixOS manages fstab declaratively; automounting must not touch it.
      substituteInPlace ../prlfsmountd.sh \
        --replace-fail '[ -f /etc/fstab ] && touch -c /etc/fstab' ""

      # install binaries
      # Leave out the upstream ptiagent self-updater: updates are managed by Nix.
      for i in bin/* sbin/prl_nettool sbin/prl_snapshot; do
        # Preserve binary offsets: NUL-pad executable paths and space-pad
        # paths embedded in shell commands.
        for p in bin/* sbin/prl_nettool sbin/prl_snapshot sbin/prlfsmountd; do
          p=$(basename $p)
          bbe \
            -e "s:/usr/bin/$p\x00:./$p\x00\x00\x00\x00\x00\x00\x00\x00:" \
            -e "s:/usr/bin/$p:$p         :" \
            -e "s:/usr/sbin/$p:$p          :" \
            -o $i.tmp $i
          mv $i.tmp $i
        done

        install -Dm755 $i $out/$i
      done

      install -Dm755 ../../tools/mount.fuse.prl_fsd $out/sbin/mount.fuse.prl_fsd
      install -Dm755 ../../tools/prlfsmountd.sh $out/sbin/prlfsmountd
      install -Dm755 ../../tools/prlbinfmtconfig.sh $out/sbin/prlbinfmtconfig
      for f in $out/bin/* $out/sbin/*; do
        wrapProgram $f \
          --prefix LD_LIBRARY_PATH ':' "${libPath}" \
          --prefix PATH ':' "${scriptPath}"
      done

      substituteInPlace ../99prltoolsd-hibernate \
        --replace-fail "/bin/bash" "${bash}/bin/bash"

      install -Dm644 ../99prltoolsd-hibernate $out/etc/pm/sleep.d
    )

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Parallels Tools for Linux guests";
    homepage = "https://parallels.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      wegank
      codgician
    ];
    platforms = lib.platforms.linux;
  };
})
