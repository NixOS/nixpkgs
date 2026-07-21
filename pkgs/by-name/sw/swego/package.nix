{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "swego";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "Swego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-28PU7jAVnWfRbFmTE2pmwJO1Zi+ceyFrzY5MiRt+91Y=";
  };

  vendorHash = "sha256-w2OhZq7vaVDVoRfnWPH0bFO85yGTFcO6KpDo5ulTifo=";

  postInstall = ''
    mv $out/bin/src $out/bin/$pname
  '';

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Simple Webserver";
    longDescription = ''
      Swiss army knife Webserver in Golang. Similar to the Python
      SimpleHTTPServer but with many features.
    '';
    homepage = "https://github.com/nodauf/Swego";
    changelog = "https://github.com/nodauf/Swego/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    # darwin crashes with:
    # src/controllers/parsingArgs.go:130:4: undefined: PrintEmbeddedFiles
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "swego";
  };
})
