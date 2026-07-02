#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. --pure -i bash -p curl cacert gnused jq common-updater-scripts dotnet-sdk_8 exiftool nix

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

old_rzls_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./package.nix)"
apiUrl="https://feeds.dev.azure.com/azure-public/vside/_apis/packaging/Feeds/msft_consumption/packages/577084ea-e5be-4fad-951b-00d0b05fb170?api-version=7.2-preview.1"
new_rzls_version="$(curl -s $apiUrl | jq -r '.versions[0].version')"

echo $old_rzls_version
echo $new_rzls_version

if [[ "$new_rzls_version" == "$old_rzls_version" ]]; then
    echo "Already up to date!"
    exit 0
fi

buildDir=$(mktemp -d)

cat > $buildDir/Server.csproj <<EOF
<Project Sdk="Microsoft.Build.NoTargets/1.0.80">
    <PropertyGroup>
        <RestorePackagesPath>out</RestorePackagesPath>
        <TargetFramework>net8.0</TargetFramework>
        <DisableImplicitNuGetFallbackFolder>true</DisableImplicitNuGetFallbackFolder>
        <AutomaticallyUseReferenceAssemblyPackages>false</AutomaticallyUseReferenceAssemblyPackages>
    </PropertyGroup>
    <ItemGroup>
        <PackageDownload Include="rzls.linux-x64" version="[${new_rzls_version}]" />
    </ItemGroup>
</Project>
EOF

dotnet restore -s "https://pkgs.dev.azure.com/azure-public/vside/_packaging/msft_consumption/nuget/v3/index.json" "$buildDir/Server.csproj"
version_commit="$(exiftool -ProductVersion -s3 $buildDir/out/rzls.linux-x64/$new_rzls_version/content/LanguageServer/linux-x64/rzls.dll | grep -Po '(?<=\+).*')"

cd ../../../..
update-source-version rzls "${new_rzls_version}" --rev=$version_commit

$(nix-build -A rzls.fetch-deps --no-out-link)
