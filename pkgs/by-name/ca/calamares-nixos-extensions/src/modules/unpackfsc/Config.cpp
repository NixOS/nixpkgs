/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#include "Config.h"

#include "utils/NamedEnum.h"

Config::Config( QObject* parent )
    : Calamares::ModuleSystem::Config( parent )
{
}

Config::~Config() {}

void
Config::setConfigurationMap( const QVariantMap& map )
{
}
