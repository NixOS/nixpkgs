begin
    for p in $PATH
        if test $p != "$PWD/bravo"
            set TEMPORARY_PATH $TEMPORARY_PATH $p
        end
    end
    set -g PATH $TEMPORARY_PATH
end
set PATH "$PWD/charlie" $PATH
