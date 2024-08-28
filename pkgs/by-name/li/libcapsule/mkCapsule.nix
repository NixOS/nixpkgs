{
  lib,
  stdenv,
  runCommand,
  autoreconfHook,
  autoconf,
  automake,
  getopt,
  pkg-config,
  libcapsule,
  libtool,
}:

{
  pname,
  dependencies,
  objects,
  meta ? {},
}@args:

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  inherit (libcapsule) version;

  outputs = [ "out" "dev" ];

  src = runCommand "${pname}-src" {
    nativeBuildInputs = [
      autoconf
      automake
      libtool
      pkg-config
    ];
    buildInputs = [
      libcapsule
    ];
    LD_LIBRARY_PATH = lib.makeLibraryPath dependencies;
  } ''
    capsule-init-project --destination=$out --package-name=${pname} --runtime-tree="/" ${lib.concatStringsSep " " objects}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    getopt
  ];
  buildInputs = [
    libcapsule
  ];

  # Do hacky stuff to pull dev outputs from dependencies that have them
  postInstall = ''
    mkdir -p $dev/include $dev/lib/pkgconfig
  '' + (lib.concatStringsSep "\n" (builtins.map (dep: ''
    cp -r ${dep.dev}/include/. $dev/include/
    for pc in $(find ${dep.dev}/lib/pkgconfig -printf "%P\n"); do
      cat "${dep.dev}/lib/pkgconfig/$pc" | sed "s|${dep}|$out|g" | sed "s|${dep.dev}|$dev|g" > $dev/lib/pkgconfig/$pc
    done
  '') (builtins.filter (dep: builtins.hasAttr "dev" dep) dependencies)));

  meta = {
    description = "libcapsule-wrapped ${lib.concatStringsSep ", " objects}";
    license = lib.licenses.gpl3Plus;
  } // meta;
})
