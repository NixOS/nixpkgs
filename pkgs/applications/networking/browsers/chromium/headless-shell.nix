{ lib
, stdenv
, callPackage
, fontconfig
, makeWrapper
, channel ? "stable"
, ungoogled ? false
}:

let
  mkChromiumDerivation = ((callPackage ./. {}).override {
    inherit channel ungoogled;
    useSystemLibffi = false;
    enableWideVine = false;
    pulseSupport = false;
    cupsSupport = false;
    proprietaryCodecs = false;
  }).passthru.mkDerivation;

in

mkChromiumDerivation (base: rec {
  name = "headless-shell";
  packageName = "chromium-headless-shell";
  buildTargets = [ "chrome_sandbox" "headless_shell" ];

  outputs = ["out"];

  gnFlags = {
    ### Copy the contents of build/args/headless.gn, as docker-headless-shell does ###
    ### Doesn't seem possible to just emit an import for that file ###
    use_ozone = true;
    ozone_auto_platforms = false;
    ozone_platform = "headless";
    ozone_platform_headless = true;
    angle_enable_vulkan = true;
    angle_enable_swiftshader = true;

    # Embed resource.pak into binary to simplify deployment.
    headless_use_embedded_resources = true;

    # Don't use Prefs component, disabling access to Local State prefs.
    headless_use_prefs = false;

    # Don't use Policy component, disabling all policies.
    headless_use_policy = false;

    # Remove a dependency on a system fontconfig library.
    use_bundled_fontconfig = true;

    # In order to simplify deployment we build ICU data file
    # into binary.
    icu_use_data_file = false;

    # Use embedded data instead external files for headless in order
    # to simplify deployment.
    v8_use_external_startup_data = false;

    enable_nacl = false;
    enable_print_preview = false;
    enable_remoting = false;
    use_alsa = false;
    use_bluez = false;
    use_cups = false;
    use_dbus = false;
    use_gio = false;
    use_kerberos = false;
    use_libpci = false;
    use_pulseaudio = false;
    use_udev = false;
    rtc_use_pipewire = false;
    v8_enable_lazy_source_positions = false;
    use_glib = false;
    use_gtk = false;
    use_pangocairo = false;

    # Extra stuff inspired by docker-headless-shell
    is_debug = false;
    symbol_level = 0;
    blink_symbol_level = 0;
  };

  installPhase = ''
    mkdir -p $out/bin

    cd "$buildPath"

    cp -a ./{headless_shell,chrome_sandbox} $out/bin
    cp -a *.so $out/bin

    rm $out/bin/libEGL.so
    rm $out/bin/libGLESv2.so

    cd $out/bin
    mv chrome_sandbox chrome-sandbox
    mv headless_shell headless-shell

    wrapProgram $out/bin/headless-shell \
      --set CHROME_DEVEL_SANDBOX $out/bin/chrome-sandbox \
      --set FONTCONFIG_PATH "${fontconfig.out}/etc/fonts/"

    chmod -x *.so
  '';

  dontFixup = true;
  postFixup = null;

  sandboxExecutableName = "chrome-sandbox";

  requiredSystemFeatures = [ "big-parallel" ];

  meta = import ./meta.nix {
    inherit lib channel ungoogled;
    headlessShell = true;
    enableWideVine = false;
  };

  passthru = {
    upstream-info = (lib.importJSON ./upstream-info.json).${channel};
    mkDerivation = mkChromiumDerivation;
    inherit sandboxExecutableName;
  };
})
