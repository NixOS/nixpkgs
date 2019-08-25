"use strict";

document.addEventListener("DOMContentLoaded", function(event) {
    const $body = document.body;

    // Allows applying rules that would break usability without JS
    $body.classList.add("with-javascript");

    // Adds the expected viewport tag dynamically.
    // This is because the current docbook output will not add one.
    const metaTag = document.createElement("meta");
    metaTag.name = "viewport";
    metaTag.content = "width=device-width, initial-scale=1";
    document.querySelector("head").appendChild(metaTag);

    // Adds the search engine
    new SearchEngine();

    // Enhance the navigation
    enhanceNavigation();
});

const enhanceNavigation = function() {
    // Adds a copy of the "up" link to the header
    let up_td = document.querySelector(".navfooter tr:first-child [align=center]").cloneNode(true);
    // If "Up" isn't there, use "Home"...
    if (!up_td.querySelector("a")) {
        up_td = document.querySelector(".navfooter tr:last-child [align=center]").cloneNode(true);
    }
    const next_td = document.querySelector(".navheader tr:last-child td[align=right]");
    next_td.parentNode.insertBefore(up_td, next_td);
}

const getDocumentationTitle = () => {
    const $link = document.querySelector("head > link[rel=home]");
    if (!$link) {
        return "";
    }

    return $link.title;
};

const SearchEngine = function() {
    const self = this;

    // http://elasticlunr.com/docs/configuration.js.html
    const cfg = {
        //fields: {title: {boost: 2}, body: {boost: 1}}
    };
    window.search = this;

    const initDOM = function() {
        const root = document.createElement("div");
        root.id = "search-engine";
        root.classList.add("is-loading");
        root.style.display = "none";
        self.root = root;

        // Lazily builds a DOM.
        root.innerHTML = `
            <div class="status">(Fetching search index...)</div>
            <input type="search" />
            <div class="results"></div>
        `;
        document.getElementsByTagName("body")[0].prepend(root);

        // Attaches to input events
        const input = root.querySelector("input");
        self.input = input;
        input.placeholder = "Search the " + getDocumentationTitle() + "...";
        input.addEventListener("keyup", (event) => search(event.target.value));

        // Adds a search icon to the header
        const icon = document.createElement("td");
        icon.classList.add("search-engine");
        icon.innerHTML = `
            <button>Search</button>
        `;
        document.querySelector(".navheader tr:last-child").prepend(icon);
        const button = icon.querySelector("button");
        button.addEventListener("click", (event) => {
            if (root.style.display === "none") {
                show();
            }
            else {
                hide();
            }
        });
    };

    const show = function() {
        document.body.classList.add("with-search");
        self.root.style.display = "block";
        self.input.focus();
    }

    const hide = function() {
        document.body.classList.remove("with-search");
        self.root.style.display = "none";
    }

    const search = function (term) {
        const $results = self.root.querySelector(".results");
        const results = self.index.search(term, cfg);

        // Lazily empties search results
        $results.innerHTML = "";
        $results.classList.remove("is-empty");

        if (term.trim() === "") {
            return;
        }

        const resultsList = document.createElement("ul");
        resultsList.append(...results.map((result) => {
            const el = document.createElement("li");
            const link = document.createElement("a");
            link.href = result.ref;
            link.innerText = result.doc.title
            el.append(link);
            const para = document.createElement("p");
            para.innerHTML = makeTeaser(result.doc.body, term.split(" "))
            el.append(para);

            // Clicks the link from the result row.
            // This way the clickable target is MUCH larger
            el.addEventListener("click", (event) => {
                link.click();
                // We're following an anchor to the current page? close the search!
                if (window.location.href.split("#")[0] === link.href.split("#")[0]) {
                    hide();
                }
            });

            return el;
        }));
        $results.append(resultsList);

        if (results.length === 0) {
            $results.classList.add("is-empty");
            $results.innerText = "Nothing could be found for “" + term + "”";
        }

    }
    self.search = search;

    initDOM();

    // Fetches the search index

    self.index = elasticlunr.Index.load(window.searchIndexData);
    self.root.querySelector(".status").innerText = "Ready!";
    self.root.classList.remove("is-loading");
    search(self.input.value);
}

// lifted from rust-lang-nursery/mdBook 84d4063e4a60f0b0fc2058b9f100f91244d60f99
// (MPL-2.0)
function makeTeaser(body, searchterms) {
    //
    const results_options = {
        teaser_word_count: 30,
    };

        // The strategy is as follows:
        // First, assign a value to each word in the document:
        //  Words that correspond to search terms (stemmer aware): 40
        //  Normal words: 2
        //  First word in a sentence: 8
        // Then use a sliding window with a constant number of words and count the
        // sum of the values of the words within the window. Then use the window that got the
        // maximum sum. If there are multiple maximas, then get the last one.
        // Enclose the terms in <em>.
        var stemmed_searchterms = searchterms.map(function(w) {
            return elasticlunr.stemmer(w.toLowerCase());
        });
        var searchterm_weight = 40;
        var weighted = []; // contains elements of ["word", weight, index_in_document]
        // split in sentences, then words
        var sentences = body.toLowerCase().split('. ');
        var index = 0;
        var value = 0;
        var searchterm_found = false;
        for (var sentenceindex in sentences) {
            var words = sentences[sentenceindex].split(' ');
            value = 8;
            for (var wordindex in words) {
                var word = words[wordindex];
                if (word.length > 0) {
                    for (var searchtermindex in stemmed_searchterms) {
                        if (elasticlunr.stemmer(word).startsWith(stemmed_searchterms[searchtermindex])) {
                            value = searchterm_weight;
                            searchterm_found = true;
                        }
                    };
                    weighted.push([word, value, index]);
                    value = 2;
                }
                index += word.length;
                index += 1; // ' ' or '.' if last word in sentence
            };
            index += 1; // because we split at a two-char boundary '. '
        };

        if (weighted.length == 0) {
            return body;
        }

        var window_weight = [];
        var window_size = Math.min(weighted.length, results_options.teaser_word_count);

        var cur_sum = 0;
        for (var wordindex = 0; wordindex < window_size; wordindex++) {
            cur_sum += weighted[wordindex][1];
        };
        window_weight.push(cur_sum);
        for (var wordindex = 0; wordindex < weighted.length - window_size; wordindex++) {
            cur_sum -= weighted[wordindex][1];
            cur_sum += weighted[wordindex + window_size][1];
            window_weight.push(cur_sum);
        };

        if (searchterm_found) {
            var max_sum = 0;
            var max_sum_window_index = 0;
            // backwards
            for (var i = window_weight.length - 1; i >= 0; i--) {
                if (window_weight[i] > max_sum) {
                    max_sum = window_weight[i];
                    max_sum_window_index = i;
                }
            };
        } else {
            max_sum_window_index = 0;
        }

        // add <em/> around searchterms
        var teaser_split = [];
        var index = weighted[max_sum_window_index][2];
        for (var i = max_sum_window_index; i < max_sum_window_index+window_size; i++) {
            var word = weighted[i];
            if (index < word[2]) {
                // missing text from index to start of `word`
                teaser_split.push(body.substring(index, word[2]));
                index = word[2];
            }
            if (word[1] == searchterm_weight) {
                teaser_split.push("<em>")
            }
            index = word[2] + word[0].length;
            teaser_split.push(body.substring(word[2], index));
            if (word[1] == searchterm_weight) {
                teaser_split.push("</em>")
            }
        };

        return teaser_split.join('');
    }
