{
  stdenv,
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  libsecret,
  git,
  git-credential-manager,
  gnupg,
  pass,
  testers,
  # optional dependencies for the msal broker runtime
  atk,
  cairo,
  curl,
  dbus,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  libsoup_3,
  libuuid,
  libx11,
  openssl,
  p11-kit,
  pango,
  webkitgtk_4_1,
  withLibsecretSupport ? true,
  withGpgSupport ? true,
  withMsalBrokerSupport ? false,
}:
let
  msalBroker =
    withMsalBrokerSupport
    # Upstream only ships the runtime for x86_64-linux and darwin
    && (stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.isDarwin);
in
buildDotnetModule rec {
  pname = "git-credential-manager";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "git-ecosystem";
    repo = "git-credential-manager";
    rev = "v${version}";
    hash = "sha256-KfNJKJhI5bvtevKzTTzSKy/bYZbY0iRK6JCItpXLLLo=";
  };

  projectFile = "src/git-credential-manager/git-credential-manager.csproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  dotnetInstallFlags = [
    "--framework"
    "net10.0"
  ];
  executables = [ "git-credential-manager" ];

  runtimeDeps = lib.optional withLibsecretSupport libsecret;
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath (
        [ git ]
        ++ lib.optionals withGpgSupport [
          gnupg
          pass
        ]
      )
    }"
    "--inherit-argv0"
  ]
  ++ lib.optionals (!msalBroker) [
    "--set-default GCM_MSAUTH_USEBROKER false"
  ];

  # msal runtime and msal wrapper libs are proprietary and non-redistributable
  postInstall = lib.optionalString (!msalBroker) ''
    rm -f $out/lib/git-credential-manager/{libmsalruntime.so,msalruntime*.dylib}
    rm $out/lib/git-credential-manager/Microsoft.Identity.Client.NativeInterop.dll
  '';

  postFixup = lib.optionalString (msalBroker && stdenv.hostPlatform.isLinux) ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        atk
        cairo
        curl
        dbus
        gdk-pixbuf
        glib
        gtk3
        harfbuzz
        libsecret
        libsoup_3
        libuuid
        libx11
        openssl
        p11-kit
        pango
        stdenv.cc.cc.lib
        webkitgtk_4_1
      ]
    } $out/lib/git-credential-manager/libmsalruntime.so
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = git-credential-manager;
    };
  };

  meta = {
    description = "Secure, cross-platform Git credential storage with authentication to GitHub, Azure Repos, and other popular Git hosting services";
    homepage = "https://github.com/git-ecosystem/git-credential-manager";
    license = [ lib.licenses.mit ] ++ lib.optional msalBroker lib.licenses.unfree;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      _999eagle
      creepycode
    ];
    longDescription = ''
      git-credential-manager is a secure, cross-platform Git credential storage with authentication to GitHub, Azure Repos, and other popular Git hosting services.

      > requires sandbox to be disabled on MacOS, so that
      .NET can find `/usr/bin/codesign` to sign the compiled binary.
      This problem is common to all .NET packages on MacOS with Nix.
    '';
    mainProgram = "git-credential-manager";
  };
}
