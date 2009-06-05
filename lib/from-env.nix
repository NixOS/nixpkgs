name: default:
let value = builtins.getEnv name; in
if value == "" then default else value
