{
  stdenv,
  cairo,
  pango,
  gdktarget ? if stdenv.hostPlatform.isDarwin then "quartz" else "x11",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk+";
  version = "2.24.33";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  meta = {
    # Not removing the gtk2 attribute from pkgs just yet leaves an opportunity
    # to migrate reverse dependencies to GTK 3.
    problems.broken = {
      message = "gtk2 was removed because because its final release 2.24.33 happened in December 2020. Packages using it should be migrated to gtk3 or later.";
      urls = [ "https://github.com/NixOS/nixpkgs/issues/410814" ];
    };
  };
})
