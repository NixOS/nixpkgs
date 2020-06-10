/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   Calamares is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Calamares is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Calamares. If not, see <http://www.gnu.org/licenses/>.
 * 
 *   SPDX-FileCopyrightText: 2020 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *   License-Filename: LICENSES/GPL-3.0
 */

#include "FreeBSDDiskViewStep.h"

FreeBSDDiskViewStep::FreeBSDDiskViewStep( QObject* parent )
    : Calamares::QmlViewStep( parent )
{
}

FreeBSDDiskViewStep::~FreeBSDDiskViewStep() {}

QString
FreeBSDDiskViewStep::prettyName() const
{
    return tr( "Disk Setup" );
}

void
FreeBSDDiskViewStep::setConfigurationMap( const QVariantMap& configurationMap )
{
    Calamares::QmlViewStep::setConfigurationMap( configurationMap ); // call parent implementation last
}

CALAMARES_PLUGIN_FACTORY_DEFINITION( FreeBSDDiskViewStepFactory, registerPlugin< FreeBSDDiskViewStep >(); )
