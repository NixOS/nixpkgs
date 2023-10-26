# shellcheck shell=bash

dartConfigHook() {
    echo "Executing dartConfigHook"

    echo "Setting up SDK"
    eval "$sdkSetupScript"

    echo "Installing dependencies"
    mkdir -p .dart_tool
    cp "$packageConfig" .dart_tool/package_config.json

    # Runs a Dart executable from a package.
    #
    # Usage:
    # packageRun <package> [executable] [bin_dir]
    #
    # By default, [bin_dir] is "bin", and [executable] is <package>.
    # i.e. `packageRun build_runner` is equivalent to `packageRun build_runner build_runner bin`, which runs `bin/build_runner.dart` from the build_runner package.
    packageRun() {
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

        local packagePath="$(jq --raw-output --arg name "$name" '.packages.[] | select(.name == $name) .rootUri | sub("file://"; "")' .dart_tool/package_config.json)"
        dart --packages=.dart_tool/package_config.json "$packagePath/$prefix/$path.dart" "${passthrough[@]}"
    }

    echo "Generating the dependency list"
    dart pub deps --json | @jq@ .packages > deps.json

    echo "Finished dartConfigHook"
}

postConfigureHooks+=(dartConfigHook)
