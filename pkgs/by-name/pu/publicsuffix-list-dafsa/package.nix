{
  stdenvNoCC,
  lzip,
  python3,
  libpsl,
  publicsuffix-list,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list-dafsa";
  inherit (publicsuffix-list) version;

  inherit (libpsl) src;

  dontConfigure = true;
  dontUpdateAutotoolsGnuConfigScripts = true;

  nativeBuildInputs = [
    lzip
    python3
  ];

  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    python3 src/psl-make-dafsa --output-format=binary \
      ${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat \
      public_suffix_list.dafsa

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0444 public_suffix_list.dafsa -t $out/share/publicsuffix

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ libpsl ];

  installCheckPhase = ''
    runHook preInstallCheck

    psl --load-psl-file $out/share/publicsuffix/public_suffix_list.dafsa co.uk | grep -F 'co.uk: 1'

    runHook postInstallCheck
  '';

  __structuredAttrs = true;

  meta = {
    description = "Public suffix list compiled to libpsl's binary DAFSA format";
    inherit (publicsuffix-list.meta) homepage license platforms;
    maintainers = [ ];
  };
}
