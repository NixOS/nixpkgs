#shellcheck shell=bash
# Setup hook for checking whether Lua imports succeed
echo "Sourcing neovim-require-check-hook.sh"

# Discover modules automatically if nvimRequireCheck is not set
discover_modules() {
    echo "Running module discovery in source directory..."

    # Create unique lists so we can organize later
    modules=()

    while IFS= read -r lua_file; do
        # Ignore certain infra directories
        if [[ "$lua_file" =~ debug/|scripts?/|tests?/|spec/ || "$lua_file" =~ .*\meta.lua ]]; then
            continue
        # Ignore optional telescope and lualine modules
        elif [[ "$lua_file" =~ ^lua/telescope/_extensions/(.+)\.lua || "$lua_file" =~ ^lua/lualine/(.+)\.lua ]]; then
            continue
        # Grab main module names
        elif [[ "$lua_file" =~ ^lua/([^/]+)/init.lua$ ]]; then
            echo "$lua_file"
            modules+=("${BASH_REMATCH[1]}")
        # Check other lua files
        elif [[ "$lua_file" =~ ^lua/(.*)\.lua$ ]]; then
            echo "$lua_file"
            # Replace slashes with dots to form the module name
            module_name="${BASH_REMATCH[1]//\//.}"
            modules+=("$module_name")
        elif [[ "$lua_file" =~ ^([^/.][^/]*)\.lua$ ]]; then
            echo "$lua_file"
            modules+=("${BASH_REMATCH[1]}")
        fi
    done < <(find "$src" -name '*.lua' | xargs -n 1 realpath --relative-to="$src")

    nvimRequireCheck=("${modules[@]}")
    echo "Discovered modules: ${nvimRequireCheck[*]}"

    if [ "${#nvimRequireCheck[@]}" -eq 0 ]; then
        echo "No valid Lua modules found; skipping check"
        return 1
    fi
    return 0
}

# Run require checks on each module in nvimRequireCheck
run_require_checks() {
    echo "Starting require checks"
    check_passed=false
    failed_modules=()
    successful_modules=()

    export HOME="$TMPDIR"
    local deps="${dependencies[*]}"
    local checks="${nativeBuildInputs[*]}"
    set +e
    for name in "${nvimRequireCheck[@]}"; do
        local skip=false
        for module in "${nvimSkipModule[@]}"; do
            if [[ "$module" == "$name" ]]; then
                echo "$name is in list of modules to not check. Skipping..."
                skip=true
                break
            fi
        done

        if [ "$skip" = false ]; then
            echo "Attempting to require module: $name"
            if @nvimBinary@ -es --headless -n -u NONE -i NONE --clean -V1 \
                --cmd "set rtp+=$out,${deps// /,}" \
                --cmd "set rtp+=$out,${checks// /,}" \
                --cmd "lua require('$name')"; then
                check_passed=true
                successful_modules+=("$name")
                echo "Successfully required module: $name"
            else
                echo "Failed to require module: $name"
                failed_modules+=("$name")
            fi
        fi
    done
    set -e
}

# Define color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Print summary of the require checks
print_summary() {
    echo -e "\n======================================================"
    if [[ "$check_passed" == "true" ]]; then
        echo -e "${GREEN}Require check succeeded for the following modules:${NC}"
        for module in "${successful_modules[@]}"; do
            echo -e "  ${GREEN}- $module${NC}"
        done
        echo "All lua modules were checked."
    else
        echo -e "${RED}No successful require checks.${NC}"
    fi

    # Print any modules that failed with improved formatting and color
    if [ "${#failed_modules[@]}" -gt 0 ]; then
        echo -e "\n${RED}Require check failed for the following modules:${NC}"
        for module in "${failed_modules[@]}"; do
            echo -e "  ${RED}- $module${NC}"
        done
    fi
    echo "======================================================"

    if [ "${#failed_modules[@]}" -gt 0 ]; then
        return 1
    fi
}

# Main entry point: orchestrates discovery, require checks, and summary
neovimRequireCheckHook() {
    echo "Executing neovimRequireCheckHook"

    if [ "${nvimRequireCheck[*]}" = "" ]; then
        echo "nvimRequireCheck is empty; entering discovery mode"
        # Auto-discovery mode
        if ! discover_modules; then
            echo "No modules found during discovery; exiting hook"
            return
        fi
    else
        echo "nvimRequireCheck is pre-populated; entering manual check mode"
    fi

    run_require_checks
    print_summary
}

echo "Using neovimRequireCheckHook"
appendToVar preDistPhases neovimRequireCheckHook
