getTargetRole
getTargetRoleWrapper

export FC${role_post}=@named_fc@

# If unset, assume the default hardening flags.
: ${NIX_HARDENING_ENABLE="@default_hardening_flags_str@"}
export NIX_HARDENING_ENABLE

unset -v role_post
