{ coreutils
, fetchFromGitHub
}:

let
  advcpmv-data = {
    pname = "advcpmv";
    patch-version = "0.9";
    coreutils-version = "9.4";
    version = "${advcpmv-data.patch-version}-${advcpmv-data.coreutils-version}";
    src = fetchFromGitHub {
      owner = "jarun";
      repo = "advcpmv";
      rev = "a1f8b505e691737db2f7f2b96275802c45f65c59";
      hash = "sha256-IHfMu6PyGRPc87J/hbxMUdosmLq13K0oWa5fPLWKOvo=";
    };
    patch-file = advcpmv-data.src + "/advcpmv-${advcpmv-data.version}.patch";
  };
  coreutilsNoSingleBinary = coreutils.override { singleBinary = false; };
in
assert (advcpmv-data.coreutils-version == coreutils.version);
coreutilsNoSingleBinary.overrideAttrs (old: {
  inherit (advcpmv-data) pname version;

  patches = (old.patches or [ ]) ++ [
    advcpmv-data.patch-file
  ];

  outputs = [ "out" ]; # Since we don't need info files

  configureFlags = (old.configureFlags or [ ]) ++ [
    # To not conflict with regular coreutils
    "--program-prefix=adv"
  ];

  # Only cpg and mvg are desired, the others are not touched and therefore can
  # be removed. Equally, the info directory is removed.
  postFixup = (old.postFixup or "") + ''
    rm -rf $out/share/info
    pushd $out/bin
    mv advcp cpg
    mv advmv mvg
    rm adv*
    mv cpg advcp
    mv mvg advmv
    ln -s advcp cpg
    ln -s advcp acp
    ln -s advmv mvg
    ln -s advmv amv
    popd
  '';

  meta = old.meta // {
    homepage = "https://github.com/jarun/advcpmv";
    description = "Patched cp and mv from Coreutils that provides progress bars";
    longDescription = ''
      Advanced Copy is a mod for the GNU cp and GNU mv tools which adds a
      progress bar and provides some info on what's going on. It was written by
      Florian Zwicke and released under the GPL.
    '';
  };
})
