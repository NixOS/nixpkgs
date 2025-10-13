{
  lib,
  fetchFromGitLab,
  fetchpatch,
  libxml2,
  fprintd,
  libfprint-tod,
  python3Packages,
  libpam-wrapper,
  gusb,
  gobject-introspection,
}:

(fprintd.override { libfprint = libfprint-tod; }).overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "fprintd-tod";
    version = "1.90.9";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "libfprint";
      repo = "fprintd";
      rev = "v${finalAttrs.version}";
      sha256 = "sha256-rOTVThHOY/Q2IIu2RGiv26UE2V/JFfWWnfKZQfKl5Mg=";
    };

    nativeBuildInputs = previousAttrs.nativeBuildInputs or [ ] ++ [
      libpam-wrapper
      python3Packages.python
      python3Packages.pycairo
      python3Packages.dbus-python
      python3Packages.python-dbusmock
      python3Packages.pygobject3
      gusb
      python3Packages.pypamtest
      gobject-introspection
      libxml2 # for xmllint
    ];

    patches = previousAttrs.patches or [ ] ++ [
      (fetchpatch {
        name = "use-more-idiomatic-correct-embedded-shell-scripting";
        url = "https://gitlab.freedesktop.org/libfprint/fprintd/-/commit/f4256533d1ffdc203c3f8c6ee42e8dcde470a93f.patch";
        hash = "sha256-4uPrYEgJyXU4zx2V3gwKKLaD6ty0wylSriHlvKvOhek=";
      })
      (fetchpatch {
        name = "remove-pointless-copying-of-files-into-build-directory";
        url = "https://gitlab.freedesktop.org/libfprint/fprintd/-/commit/2c34cef5ef2004d8479475db5523c572eb409a6b.patch";
        hash = "sha256-2pZBbMF1xjoDKn/jCAIldbeR2JNEVduXB8bqUrj2Ih4=";
      })
      (fetchpatch {
        name = "build-Do-not-use-positional-arguments-in-i18n.merge_file";
        url = "https://gitlab.freedesktop.org/libfprint/fprintd/-/commit/50943b1bd4f18d103c35233f0446ce7a31d1817e.patch";
        hash = "sha256-ANkAq6fr0VRjkS0ckvf/ddVB2mH4b2uJRTI4H8vPPes=";
      })
      (fetchpatch {
        name = "tests-Fix-dbusmock-AddDevice-calls-to-include-option";
        url = "https://gitlab.freedesktop.org/libfprint/fprintd/-/commit/ae04fa989720279e5558c3b8ff9ebe1959b1cf36.patch";
        hash = "sha256-jW5vlzrbZQ1gUDLBf7G50GnZfZxhlnL2Eu+9Bghdwdw=";
      })
    ];

    postPatch = previousAttrs.postPatch or "" + ''
      # part of "remove-pointless-copying-of-files-into-build-directory" but git-apply doesn't handle renaming
      mv src/device.xml src/net.reactivated.Fprint.Device.xml
      mv src/manager.xml src/net.reactivated.Fprint.Manager.xml
    '';

    meta = {
      homepage = "https://fprint.freedesktop.org/";
      description = "fprintd built with libfprint-tod to support Touch OEM Drivers";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ hmenke ];
    };
  }
)
