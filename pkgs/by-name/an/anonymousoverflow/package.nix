{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "anonymousoverflow";
  version = "1.13.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "httpjamesm";
    repo = "AnonymousOverflow";
    tag = "v1.13.0";
    hash = "sha256-hvcOJctvNswEws+cCoeGQSvFzZvnThhKk3fJ7TnNulY=";
  };

  vendorHash = "sha256-P3kUGFJhj/pTNeVTwtg4IqhoHBH9rROfkr+ZsrUtmdo=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  env.CGO_ENABLED = 0;

  postInstall = ''
    install -d $out/share/anonymousoverflow
    cp -r templates public $out/share/anonymousoverflow/

    wrapProgram $out/bin/anonymousoverflow \
      --chdir "$out/share/anonymousoverflow"
  '';

  meta = {
    description = "Privacy-friendly alternative frontend for Stack Overflow";
    longDescription = ''
      AnonymousOverflow is a lightweight server-side rendered frontend for
      Stack Overflow threads that proxies requests through the instance.
    '';
    homepage = "https://github.com/httpjamesm/${finalAttrs.repo}";
    changelog = "https://github.com/httpjamesm/${finalAttrs.repo}/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = finalAttrs.pname;
  };
})
