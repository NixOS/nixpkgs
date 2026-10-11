{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeWrapper,
  libpcap,
  libnl,
}:
buildGoModule (finalAttrs: {
  pname = "minimega";
  version = "3.0.1";

  # For version.go
  rev = "1fe073faa4eceb6056de1bc400fd782c0e40c164";

  src = fetchFromGitHub {
    owner = "sandia-minimega";
    repo = "minimega";
    tag = finalAttrs.version;
    hash = "sha256-i+xIUyWrOCv5DvcRBSwRQM3+XYPMvUKO2n/wsSJR2ms=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  vendorHash = null;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    libpcap
    libnl
  ];

  subPackages = [
    "cmd/..."
  ];

  excludedPackages = [
    "cmd/plumbing"
  ];

  postPatch = ''
    # Link libnl for static builds
    substituteInPlace vendor/github.com/google/gopacket/pcap/pcap_unix.go \
      --replace-fail "-lpcap" "-lpcap -lnl-genl-3 -lnl-3"
  '';

  preBuild = ''
    # Create the version.go file for minimega (see scripts/build.bash in src)
    echo "package version

    var (
      Version  = \"${finalAttrs.version}\"
      Revision = \"${finalAttrs.rev}\"
      Date     = \"$(date -d @$SOURCE_DATE_EPOCH --rfc-3339=date)\"
    )" > internal/version/version.go
  '';

  postBuild = ''
    # Generate API docs for minimega and minirouter
    $GOPATH/bin/apigen -bin $GOPATH/bin/minimega \
                -template doc/content_templates/minimega_api.template \
                -sections .,mesh,vm,host \
                > doc/content/articles/api.article
    $GOPATH/bin/apigen -bin $GOPATH/bin/minirouter \
                -template doc/content_templates/minirouter_api.template \
                -sections . \
                > doc/content/articles/minirouter_api.article
  '';

  postInstall = ''
    # Copy out the docs for minidoc
    mkdir $out/doc
    cp -r doc/* $out/doc/

    # Copy out the assets for miniweb
    mkdir -p $out/share/web
    cp -r web/* $out/share/web
  '';

  postFixup = ''
    # Wrap miniweb to pass the webroot
    wrapProgram $out/bin/miniweb \
      --add-flags "-root $out/share/web"

    # Wrap minidoc to pass the base and root paths
    wrapProgram $out/bin/minidoc \
      --add-flags "-base $out/share/doc/template" \
      --add-flags "-root $out/share/doc/content"
  '';

  meta = {
    description = "Tool for launching and managing virtual machines";
    homepage = "https://www.sandia.gov/minimega";
    changelog = "https://github.com/sandia-minimega/minimega/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tbaldwin ];
    mainProgram = "minimega";
  };
})
