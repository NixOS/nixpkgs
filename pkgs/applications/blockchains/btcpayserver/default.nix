{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, altcoinSupport ? false }:

buildDotnetModule rec {
  pname = "btcpayserver";
<<<<<<< HEAD
  version = "1.11.4";
=======
  version = "1.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-PJhc+Kv/iZ73DkM9KXzujTsIc071wqn/NKhuUPs/7dA=";
=======
    sha256 = "sha256-N/6/a9K8ROSJ+rsip85Av1jmggI12Clr61+9Dh56Lls=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  projectFile = "BTCPayServer/BTCPayServer.csproj";
  nugetDeps = ./deps.nix;

  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  buildType = if altcoinSupport then "Altcoins-Release" else "Release";

  # macOS has a case-insensitive filesystem, so these two can be the same file
  postFixup = ''
    mv $out/bin/{BTCPayServer,btcpayserver} || :
  '';

  meta = with lib; {
    description = "Self-hosted, open-source cryptocurrency payment processor";
    homepage = "https://btcpayserver.org";
    maintainers = with maintainers; [ kcalvinalvin erikarvstedt ];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
