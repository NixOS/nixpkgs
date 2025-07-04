function update_cwd_osc --on-variable PWD --description 'Notify terminals when $PWD changes'
    if status --is-command-substitution || set -q INSIDE_EMACS
        return
    end
    printf \e\]7\;file://%s%s\e\\ $hostname (string escape --style=url $PWD)
end

update_cwd_osc # Run once since we might have inherited PWD from a parent shell

function mark_prompt_start --on-event fish_prompt
    echo -en "\e]133;A\e\\"
end

function foot_cmd_start --on-event fish_preexec
  echo -en "\e]133;C\e\\"
end

function foot_cmd_end --on-event fish_postexec
  echo -en "\e]133;D\e\\"
end
