{ lib
, bundlerApp
, makeWrapper
, kubectl
, bundlerUpdateScript
}:

bundlerApp {
  pname = "krane";
  gemdir = ./.;
  exes = [ "krane" ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/krane" \
      --prefix PATH : ${lib.makeBinPath [ kubectl ]}
  '';

  passthru.updateScript = bundlerUpdateScript "krane";

  meta = with lib; {
    description = "A command-line tool that helps you ship changes to a Kubernetes namespace and understand the result";
    homepage = "https://github.com/Shopify/krane";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
