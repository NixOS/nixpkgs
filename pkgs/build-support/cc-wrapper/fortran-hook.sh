getTargetRole
getTargetRoleWrapper

export FC${role_post}=@named_fc@

# If unset, assume the default hardening flags.
if [[ ! -v NIX_HARDENING_ENABLE${role_post} ]]; then
    declare NIX_HARDENING_ENABLE${role_post}="@default_hardening_flags_str@"
fi
export NIX_HARDENING_ENABLE${role_post}

unset -v role_post
