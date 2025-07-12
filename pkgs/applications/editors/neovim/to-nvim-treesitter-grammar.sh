echo "Sourcing to-nvim-treesitter-grammar.sh"

toNvimTreesitterGrammar() {
    echo "Executing toNvimTreesitterGrammar"

    mkdir -p "$out/parser"
    ln -s "$origGrammar/parser" "$out/parser/$grammarName.so"

    if [ "$installQueries" != 1 ]; then
        echo "Installing queries is disabled: installQueries=$installQueries"
        return
    fi

    echo "Installing queries for $grammarName"

    mkdir -p "$out/queries/$grammarName"
    if [ -d "$origGrammar/queries/$grammarName" ]; then
        echo "Moving queries from neovim queries dir"
        for file in "$origGrammar/queries/$grammarName/"*; do
            ln -s "$file" "$out/queries/$grammarName/$(basename "$file")"
        done
    else
        if [ -d "$origGrammar/queries" ]; then
            echo "Moving queries from standard queries dir"

            for file in "$origGrammar/queries/"*; do
                ln -s "$file" "$out/queries/$grammarName/$(basename "$file")"
            done
        else
            echo "Missing queries for $grammarName"
        fi
    fi
}

echo "Using toNvimTreesitterGrammar"
preDistPhases+=" toNvimTreesitterGrammar"
