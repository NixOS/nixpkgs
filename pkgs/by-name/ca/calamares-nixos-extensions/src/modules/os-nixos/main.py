#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# === This file is part of Calamares - <https://github.com/calamares> ===
#
#   Calamares is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   Calamares is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with Calamares. If not, see <http://www.gnu.org/licenses/>.
#
#   SPDX-FileCopyrightText: 2019 Adriaan de Groot <groot@kde.org>
#   SPDX-License-Identifier: GPL-3.0-or-later
#   License-Filename: LICENSE
#

"""
=== NixOS Configuration

NixOS has its own "do all the things" configuration file which
declaratively handles what things need to be done in the target
system, and it has an existing tool to "execute" that declarative
specification. This module takes configuration values set by
Calamares viewmodules (e.g. the users module) and puts
them into the configuration file in the target system,
and then runs the necessary NixOS specific tools.
"""

import libcalamares
import os
from time import gmtime, strftime, sleep

import gettext
_ = gettext.translation("calamares-python",
                        localedir=libcalamares.utils.gettext_path(),
                        languages=libcalamares.utils.gettext_languages(),
                        fallback=True).gettext


def pretty_name():
    return _("NixOS Configuration.")


def run():
    """NixOS Configuration."""
    libcalamares.utils.debug("LocaleDir=" +
                             str(libcalamares.utils.gettext_path()))
    libcalamares.utils.debug("Languages=" +
                             str(libcalamares.utils.gettext_languages()))

    # TODO: probably want to use the job configuration
    #       with a key "stage" to distinguish generate-config
    #       from execute-config; maybe it wants an "all" as well
    #       to do both.
    accumulator = "*** Job configuration\n"
    accumulator += str(libcalamares.job.configuration)
    libcalamares.utils.debug(accumulator)

    accumulator = "*** GlobalStorage configuration\n"
    accumulator += "count: " + str(libcalamares.globalstorage.count()) + "\n"
    accumulator += "keys: {}\n".format(str(libcalamares.globalstorage.keys()))
    libcalamares.utils.debug(accumulator)

    libcalamares.utils.debug("Run NixOS tools.")

    libcalamares.job.setprogress( 0.1 )
    sleep(1)
    libcalamares.job.setprogress( 0.5 )
    sleep(1)
    libcalamares.job.setprogress( 1.0 )

    sleep(3)

    # To indicate an error, return a tuple of:
    # (message, detailed-error-message)
    return None
