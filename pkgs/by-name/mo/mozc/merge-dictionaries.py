# SPDX-License-Identifier: Apache-2.0
# Adapted from merge-ut-dictionaries by UTUMI Hirosi
# https://github.com/utuhiro78/merge-ut-dictionaries/blob/main/src/merge/merge_dictionaries.py
# Snapshot: 6239884099ddc0c4d5bb1453b20441121d20593e
#
# Merge already-generated UT dictionaries into an additional Mozc dictionary.
# This keeps upstream's normalization, duplicate selection and ranking rules,
# but reads pinned local files instead of downloading Mozc/Wikipedia data.
# It does not generate the individual dictionaries or replace their filters.

import bz2
import csv
import gzip
import html
import sys
from pathlib import Path
from unicodedata import normalize


def normalize_form(form):
    # Fold compatibility characters (e.g. fullwidth Latin letters), then use
    # the Japanese wave dash in place of the ASCII tilde, as upstream does.
    return normalize("NFKC", form).replace("~", "〜")


def valid_form(form):
    # Reject one-character words and overly long conversion candidates.
    # Upstream checks length BEFORE normalization; keep that order here too.
    return 2 <= len(form) <= 25


def read_mozc(source):
    dictionary_dir = Path(source) / "src/data/dictionary_oss"
    # Context IDs depend on the Mozc version. Find its general-noun ID instead
    # of trusting IDs in dictionaries generated against other versions.
    with (dictionary_dir / "id.def").open(encoding="utf-8") as definitions:
        noun_id = next(
            line.split(" 名詞,一般,")[0]
            for line in definitions
            if " 名詞,一般," in line
        )

    # A set of (reading, normalized form) lets us exclude entries that Mozc
    # already knows, regardless of their original costs or context IDs.
    known = set()
    for path in sorted(dictionary_dir.glob("dictionary0*.txt")):
        with path.open(encoding="utf-8") as dictionary:
            for row in csv.reader(dictionary, delimiter="\t"):
                if len(row) >= 5 and valid_form(row[4]):
                    known.add((row[0], normalize_form(row[4])))
    return known, noun_id


def wikipedia_hits(path):
    # The main-namespace dump has a header and one underscore-separated title
    # per line, as a local alternative to upstream's multistream index.
    skip = (
        "ファイル:", "Wikipedia:", "Template:", "Portal:",
        "Help:", "Category:", "プロジェクト:", "曖昧さ回避",
    )
    words = set()
    with gzip.open(path, "rt", encoding="utf-8") as titles:
        next(titles)  # page_title header
        for line in titles:
            form = html.unescape(line.rstrip().replace("_", " "))
            # Match upstream: use the qualifier after " (", when present.
            # An album title's qualifier can contribute artist hits.
            form = form.split(" (")[-1]
            if valid_form(form) and not form.startswith(skip):
                words.add(normalize_form(form))

    # In sorted titles, all strings starting with a given title are adjacent.
    # Count matches for EVERY title, not just the first in each prefix group:
    # AB, ABC, ABCD must give counts 3, 2, 1 respectively.
    words = sorted(words)
    hits = {}
    for index, word in enumerate(words):
        count = 1
        while (
            index + count < len(words)
            and words[index + count].startswith(word)
        ):
            count += 1
        hits[word] = count
    return hits


def main():
    if len(sys.argv) < 5:
        sys.exit(
            "Usage: merge-dictionaries.py "
            "OUTPUT MOZC_SOURCE TITLES_GZ DICTIONARY_BZ2..."
        )
    output, mozc_source, title_dump, *dictionaries = sys.argv[1:]
    known, noun_id = read_mozc(mozc_source)

    # Dictionary order is significant: for duplicate UT entries, keep the first
    # selected source's cost, NOT the cheapest cost. Mozc's built-in entries
    # win over all UT sources; insertion order preserves upstream's ties.
    unique = {}
    for path in dictionaries:
        with bz2.open(path, "rt", encoding="utf-8") as dictionary:
            for reading, _left_id, _right_id, cost, form in csv.reader(
                dictionary, delimiter="\t"
            ):
                if not valid_form(form):
                    continue
                form = normalize_form(form)
                if (reading, form) not in known:
                    unique.setdefault((reading, form), cost)

    hits = wikipedia_hits(title_dump)
    result = []
    for (reading, form), raw_cost in unique.items():
        cost = int(raw_cost)
        count = min(hits.get(form, 0), 30)
        # Lower costs favor a candidate. Wikipedia prefix hits approximate its
        # prominence; cap their influence and demote entries with few/no hits.
        if form.isascii():
            if count == 0:
                continue  # Avoid unsupported ASCII-only conversion candidates.
            cost = 9000 + cost // 20
        elif count == 0:
            cost = 9000 + cost // 20
        elif count == 1:
            cost = 8000 + cost // 20
        else:
            cost = 8000 - count * 10
        # Treat all added entries as general nouns using this Mozc's IDs.
        result.append((reading, noun_id, noun_id, str(cost), form))

    # Sort rows with costs as strings, matching upstream's output order.
    result.sort()
    with open(output, "w", encoding="utf-8") as dictionary:
        for row in result:
            dictionary.write("\t".join(row) + "\n")


if __name__ == "__main__":
    main()
