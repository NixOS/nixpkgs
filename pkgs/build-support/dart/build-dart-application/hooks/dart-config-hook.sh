# shellcheck shell=bash

dartConfigHook() {
    echo "Executing dartConfigHook"

    echo "Setting up SDK"
    eval "$sdkSetupScript"

    echo "Installing dependencies"
    mkdir -p .dart_tool
    cp "$packageConfig" .dart_tool/package_config.json

    packagePath() {
        jq --raw-output --arg name "$1" '.packages.[] | select(.name == $name) .rootUri | sub("file://"; "")' .dart_tool/package_config.json
    }

    # Runs a Dart executable from a package with a custom path.
    #
    # Usage:
    # packageRunCustom <package> [executable] [bin_dir]
    #
    # By default, [bin_dir] is "bin", and [executable] is <package>.
    # i.e. `packageRunCustom build_runner` is equivalent to `packageRunCustom build_runner build_runner bin`, which runs `bin/build_runner.dart` from the build_runner package.
    packageRunCustom() {
        local args=()
        local passthrough=()

        while [ $# -gt 0 ]; do
            if [ "$1" != "--" ]; then
                args+=("$1")
                shift
            else
                shift
                passthrough=("$@")
                break
            fi
        done

        local name="${args[0]}"
        local path="${args[1]:-$name}"
        local prefix="${args[2]:-bin}"

        dart --packages=.dart_tool/package_config.json "$(packagePath "$name")/$prefix/$path.dart" "${passthrough[@]}"
    }

    # Runs a Dart executable from a package.
    #
    # Usage:
    # packageRun <package> [-e executable] [...]
    #
    # To run an executable from an unconventional location, use packageRunCustom.
    packageRun() {
        local name="$1"
        shift

        local executableName="$name"
        if [ "$1" = "-e" ]; then
          shift
          executableName="$1"
          shift
        fi

        fileName="$(@yq@ --raw-output --arg name "$executableName" '.executables.[$name] // $name' "$(packagePath "$name")/pubspec.yaml")"
        packageRunCustom "$name" "$fileName" -- "$@"
    }

    echo "Finished dartConfigHook"
}

postConfigureHooks+=(dartConfigHook)
