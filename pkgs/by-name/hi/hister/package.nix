{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  sqlite,
  yt-dlp,
  makeBinaryWrapper,
  pkg-config,
}:

let
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "hister";
    tag = "v${version}";
    hash = "sha256-jL26JxvaDZtt5+P67V+DEDAafYgBaJg4OE87AdYxAdo=";
  };

  frontend = buildNpmPackage {
    pname = "hister-frontend";
    inherit version src;

    npmWorkspace = "webui/app";
    npmDepsHash = "sha256-LiHkFHe99q95LhbYPWIIhxj8/R+JjNZ8bgShPBgmAN8=";

    # vite 8's rolldown pipeline does a dns.lookup('localhost') during `vite build`
    # which fails in darwin's relaxed sandbox without loopback access
    __darwinAllowLocalNetworking = true;

    preBuild = ''
      patchShebangs webui
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -r webui/app/build/* "$out/"
      runHook postInstall
    '';
  };
in
buildGoModule (finalAttrs: {
  pname = "hister";
  inherit version src;

  __structuredAttrs = true;

  vendorHash = "sha256-PngBSNsYL2eQ7aIFCl1DpYtawMNNeAlDjukXttPVEfc=";
  proxyVendor = true;

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [ sqlite ];

  tags = [ "libsqlite3" ];

  preBuild = ''
    mkdir -p server/static/app
    cp -r ${frontend}/* server/static/app/
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  postInstall = ''
    wrapProgram $out/bin/hister \
      --prefix PATH : ${lib.makeBinPath [ yt-dlp ]}
  '';

  passthru = {
    inherit frontend;
  };

  meta = {
    description = "Web history on steroids - blazing fast, content-based search for visited websites";
    homepage = "https://github.com/asciimoo/hister";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ FlameFlag ];
    mainProgram = "hister";
    platforms = lib.platforms.unix;
  };
})
