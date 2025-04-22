{
  swift,
  swiftpm,
  swiftPackages,
  substitute,
  installShellFiles,
  testers,
  version,
  meta,
  cacert,
  enableSwiftDylibFix ? false,
  fixSwiftDylib,
  repoSrc,
  mas-from-src,
}:

swiftPackages.stdenv.mkDerivation rec {
  pname = "mas-from-src";
  inherit version meta;
  src = repoSrc;

  nativeBuildInputs = [
    installShellFiles
    swift
    swiftpm
    cacert # git via swiftpm needs cacert to verify identities when obaining dependecies
  ];

  # variables must NOT contain "@"
  createSourceMasPackageDotSwift = substitute {
    src = ./create_source_mas_package_dot_swift.patch;
    substitutions = [
      "--replace-fail"
      "@version@"
      version
      "--replace-fail"
      "@installMethod@"
      "nixpkgs/${pname}"
      "--replace-fail"
      "@gitOrigin@"
      repoSrc.gitRepoUrl
      "--replace-fail"
      "@gitRevision@"
      repoSrc.rev
      "--replace-fail"
      "@swiftVersion@"
      "${swift.version} (nixpkgs)"
      "--replace-fail"
      "@swiftDriverVersion@"
      "${swift.version} (nixpkgs)" # swift on nixpkgs includes swift-driver by default
    ];
  };
  patches = [
    createSourceMasPackageDotSwift
  ];

  # git via swiftpm needs cacert to verify identities when obaining dependecies
  buildPhase = ''
    runHook preBuild

    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-certificates.crt"
    swift build --configuration release --disable-sandbox --manifest-cache none

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D ".build/release/mas" "$out/bin/mas"

    installShellCompletion --cmd mas --bash "contrib/completion/mas-completion.bash"
    installShellCompletion --cmd mas --fish "contrib/completion/mas.fish"

    runHook postInstall
  '';

  postFixup =
    if enableSwiftDylibFix then (fixSwiftDylib swift "${swift.swift.lib}/lib/swift-5.5/macosx") else "";

  passthru.tests = {
    version = testers.testVersion {
      package = mas-from-src;
      command = "mas version";
    };
  };
}
