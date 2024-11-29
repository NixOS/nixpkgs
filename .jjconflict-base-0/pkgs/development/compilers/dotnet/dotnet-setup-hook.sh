if [ ! -w "$HOME" ]; then
    export HOME=$(mktemp -d) # Dotnet expects a writable home directory for its configuration files
fi

export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 # Dont try to expand NuGetFallbackFolder to disk
export DOTNET_NOLOGO=1 # Disables the welcome message
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SKIP_WORKLOAD_INTEGRITY_CHECK=1 # Skip integrity check on first run, which fails due to read-only directory
