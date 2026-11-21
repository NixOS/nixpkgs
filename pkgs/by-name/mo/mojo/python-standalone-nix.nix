{
  lib,
  stdenv,
  python,
  patchelf,
}:

# rules_python's python_repository expects a python-build-standalone
# install_only archive: prefix `python/{bin,lib,include}` after strip_prefix.
# nixpkgs CPython already has that layout and a Nix PT_INTERP / rpath.
stdenv.mkDerivation {
  pname = "mojo-python-standalone";
  inherit (python) version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  # Keep the copied interpreter's glibc PT_INTERP; do not wrap $out (a tarball).
  dontFixup = true;

  nativeBuildInputs = [ patchelf ];

  installPhase = ''
    runHook preInstall

    mkdir -p python/bin
    # Skip idle/pydoc: nixpkgs uses hardlinks that Bazel's extractor rejects.
    cp -a ${python}/bin/python ${python}/bin/python3 ${python}/bin/python${python.pythonVersion} python/bin/
    cp -a ${python}/bin/python-config ${python}/bin/python3-config python/bin/ || true
    cp -a ${python}/lib ${python}/include python/
    chmod -R u+w python
    mkdir -p python/lib/python${python.pythonVersion}/distutils

    # Relocate like python-build-standalone so extract works without the
    # original python store path in the sandbox.
    interp="$(readlink -f python/bin/python3)"
    old_rpath="$(patchelf --print-rpath "$interp")"
    patchelf --set-rpath "\$ORIGIN/../lib''${old_rpath:+:}''${old_rpath}" "$interp"

    mkdir -p "$out"
    tar --hard-dereference --sort=name --mtime=@1 --owner=0 --group=0 --numeric-owner \
      -czf "$out/python.tar.gz" python

    runHook postInstall
  '';

  passthru = {
    inherit python;
  };

  meta = {
    description = "nixpkgs CPython packed as a python-build-standalone install_only archive";
    license = lib.licenses.psfl;
    platforms = [ "x86_64-linux" ];
  };
}
